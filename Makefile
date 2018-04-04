SHELL := /bin/bash
BASEDIR := $(CURDIR)
ORGIN := $(BASEDIR)/org-files
ORGIN_LT := $(ORGIN)/ltximg
ORGOUT := $(BASEDIR)/org-html
GITHUB := /var/www/localhost/htdocs/dwhoman
TMPDIR := $(BASEDIR)/tmp
GENERATED := $(BASEDIR)/generated
BLOG := $(GITHUB)/blog
BLOG_LT := $(BLOG)/ltximg

main_css_version := $(shell stat -c "%Y" $(GITHUB)/css/main.css)
categories_css_version := $(shell stat -c "%Y" $(GITHUB)/css/categories.css)

XSLT := xsltproc --nodtdattr --nonet --novalid
XSLT_categories := $(XSLT) --stringparam css_version $(categories_css_version)
XSLT_page_template := $(XSLT) --stringparam css_version $(main_css_version)

.PHONY: site

site: metadata.xml feed updates_page published_page blog_posts categories threads resume_page page-template-xml about_page home_page

page-template-xml: $(BASEDIR)/page-template.xsl $(BASEDIR)/page-template-xml.xsl
	$(XSLT) $(BASEDIR)/page-template-xml.xsl $(BASEDIR)/page-template.xsl > $(GENERATED)/page-template.xsl

diacritics-dashes: $(BASEDIR)/diacritics-dashes.xml $(BASEDIR)/create-diacritics-dashes-st.xsl
	$(XSLT) $(BASEDIR)/create-diacritics-dashes-st.xsl $(BASEDIR)/diacritics-dashes.xml > $(GENERATED)/diacritics-dashes.xsl

metadata.xml: $(BASEDIR)/description.xsl $(BASEDIR)/index-pages.awk $(BASEDIR)/org-xhtml-keywords.xsl $(BASEDIR)/threads.gxl $(BASEDIR)/thread-pointers.xsl $(BASEDIR)/get-thread-pointer.xsl
	$(XSLT) thread-pointers.xsl threads.gxl > $(GENERATED)/thread-pointers.xml
	find $(ORGOUT) -maxdepth 1 \( ! -regex '.*/\..*' \) -type f -printf "%f\n" -name "*.html"\
	| parallel -k --will-cite '$(XSLT) --stringparam file "{}" $(BASEDIR)/org-xhtml-keywords.xsl $(ORGOUT)/"{}"'\
	| sed -e '/^following\.html/d'\
	| tee $(TMPDIR)/metadata.csv\
	| awk -f $(BASEDIR)/index-pages.awk > $(GENERATED)/$@

feed: metadata.xml $(BASEDIR)/atom-feed.xsl
	$(XSLT) $(BASEDIR)/atom-feed.xsl $(GENERATED)/metadata.xml > $(GITHUB)/feed.atom

# page with posts sorted by most recently updated
updates_page: metadata.xml $(BASEDIR)/page-template.xsl $(BASEDIR)/indexed-by-date.xsl
	$(XSLT) --stringparam title 'Updates' --param order 1 $(BASEDIR)/indexed-by-date.xsl $(GENERATED)/metadata.xml\
	| $(XSLT_page_template) $(BASEDIR)/page-template.xsl - > $(GITHUB)/recent-updates.html

# page with posts sorted by most recently published
published_page: metadata.xml $(BASEDIR)/page-template.xsl $(BASEDIR)/indexed-by-date.xsl
	$(XSLT) --stringparam title 'Publications' $(BASEDIR)/indexed-by-date.xsl $(GENERATED)/metadata.xml\
	| $(XSLT_page_template) $(BASEDIR)/page-template.xsl - > $(GITHUB)/chronological.html

# convert org html export to page formatted for the blog
blog_posts: metadata.xml $(BASEDIR)/blog-post-main.xsl $(BASEDIR)/page-template.xsl blog_post_images blog_post_formulas
	find $(ORGOUT) -maxdepth 1 \( ! -regex '.*/\..*' \) -type f -printf "%f\n" -name "*.html"\
	| parallel --will-cite 'sed -f $(BASEDIR)/html2unicode.sed $(ORGOUT)/"{}" | tee $(TMPDIR)/"{}" | $(XSLT) --stringparam file {.} --stringparam metadata $(GENERATED)/metadata.xml $(BASEDIR)/blog-post-main.xsl - | $(XSLT_page_template) --stringparam relative .. $(BASEDIR)/page-template.xsl - > $(BLOG)/{}; touch $(GITHUB)/css/{.}.css'
	cp $(ORGIN)/*.org $(BLOG)/

blog_post_formulas: $(BASEDIR)/latex-svg-edit.xsl
	find $(ORGIN_LT) -maxdepth 1 \( ! -regex '.*/\..*' \) -type f -name "*.svg" -printf "%f\n"\
	| parallel --will-cite '$(XSLT) $(BASEDIR)/latex-svg-edit.xsl $(ORGIN_LT)/{} > $(BLOG_LT)/{}'

# rsync raster graphics
# remove edit svgs before uploading
blog_post_images: $(BASEDIR)/svg-edit.xsl
	for d in $$(find $(ORGIN) -maxdepth 1 \( ! -regex '.*/\..*' \) -type f -name "*.org" | sed -e 's/\(.*\)\.org/\1/'); do \
	if [[ -d $$d ]]; then \
	rsync -m --include='*.png' --include='*.jpg' --include='*.jpeg'  --exclude="*" $$d/* $(BLOG)/$${d##*/};\
	find $$d -maxdepth 1 -type "f" -name "*.svg" -printf "$${d##*/}/%f\n"\
	| parallel --will-cite '$(XSLT) $(BASEDIR)/svg-edit.xsl $(ORGIN)/{} > $(BLOG)/{}'; \
	fi \
	done

# page with posts grouped by category/keyword
categories: metadata.xml $(BASEDIR)/categories.xsl page-template-xml
	$(XSLT_categories)  $(BASEDIR)/categories.xsl $(GENERATED)/metadata.xml\
	| $(XSLT_page_template) $(GENERATED)/page-template.xsl -\
	| sed -f $(BASEDIR)/categories-processing.sed > $(GITHUB)/categories.xhtml

# page with posts grouped by thread
threads: $(BASEDIR)/threads.gxl $(BASEDIR)/page-template.xsl
	gxl2dot $(BASEDIR)/threads.gxl | dot -Tsvg\
	| $(XSLT) $(BASEDIR)/threads.xsl - \
	| $(XSLT_page_template) $(BASEDIR)/page-template.xsl - > $(GITHUB)/threads.html

# written Latin characters: 0021 - 007E
# common ligatures: FB00 - FB04, nbsp A0
GLYPHS := --unicodes="U+0021-007E" --unicodes="U+FB00-FB04"
# common diacritics 00E9 é  00E7 ç 00EF ï
# quote marks 2018 2019 201C 201D
#--unicodes="U+E7" --unicodes="U+E9" --unicodes="U+EF"
#GLYPHS += --unicodes="U+2018-2018" --unicodes="U+201C-201D" --unicodes="U+0301"
# small caps
#GLYPHS += --unicodes="U+0250–02AF" --unicodes="U+1D00–1D7F" --unicodes="U+A720–A7FF"

%.woff: 
	pyftsubset --output-file=$(GITHUB)/fonts/$@ $(BASEDIR)/fonts/$(FONTDIR)/$@ $(GLYPHS)

cmunbi.woff  cmunbx.woff  cmunrm.woff  cmunti.woff: FONTDIR = Serif

cmunit.woff  cmuntb.woff  cmuntt.woff  cmuntx.woff: FONTDIR = Typewriter

cmunobi.woff  cmunobx.woff  cmunorm.woff  cmunoti.woff: FONTDIR = Concrete

cmunssdc.woff: FONTDIR = Sans_Demi-Condensed

cmunvi.woff  cmunvt.woff: FONTDIR = Typewriter_Variable

cmunsi.woff cmunso.woff cmunss.woff cmunsx.woff: FONTDIR = Sans

cmunbtl.woff cmunbto.woff: FONTDIR = Typewriter_Light

fonts: cmunbi.woff  cmunbx.woff  cmunrm.woff  cmunti.woff cmunit.woff  cmuntb.woff  cmuntt.woff  cmuntx.woff cmunobi.woff  cmunobx.woff  cmunorm.woff  cmunoti.woff cmunssdc.woff cmunvi.woff  cmunvt.woff cmunsi.woff cmunso.woff cmunss.woff cmunsx.woff cmunbtl.woff cmunbto.woff

# probably put copy of the most recent post
#home_page: blog_posts $(BASEDIR)/page-template.xsl
home_page: resume_page
	cp $(GITHUB)/resume.html $(GITHUB)/index.html

about_page: $(BASEDIR)/page-template.xsl $(BASEDIR)/about.html
	$(XSLT_page_template) $(BASEDIR)/page-template.xsl $(BASEDIR)/about.html > $(GITHUB)/about.html

resume_page: $(BASEDIR)/page-template.xsl $(BASEDIR)/resume.html
	$(XSLT_page_template) $(BASEDIR)/page-template.xsl $(BASEDIR)/resume.html > $(GITHUB)/resume.html

resume_pdf: $(BASEDIR)/resume.html $(BASEDIR)/resume-latex.xsl $(BASEDIR)/resume-latex.sed
	$(XSLT) $(BASEDIR)/resume-latex.xsl $(BASEDIR)/resume.html\
	| sed -f $(BASEDIR)/resume-latex.sed > $(TMPDIR)/resume-latex.tex
	pdflatex -output-directory=$(GENERATED) -aux-directory=$(TMPDIR) $(TMPDIR)/resume-latex.tex

resume_txt: $(BASEDIR)/resume.html $(BASEDIR)/resume-text.xsl $(BASEDIR)/resume-text.sed
	$(XSLT) $(BASEDIR)/resume-text.xsl $(BASEDIR)/resume.html\
	| sed -f $(BASEDIR)/resume-text.sed > $(GENERATED)/resume-latex.txt
