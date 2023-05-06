.PHONE: check_pandoc gen_doc

check_pandoc:
	pandoc --version

gen_doc: check_pandoc docs/*.md
	pandoc docs/*.md --to=markdown -o README.md