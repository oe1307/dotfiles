run:
	exec marp -p _marp.md --html --theme ~/dotfiles/config/marp/ntt.css

install: 
	exec marp _marp.md --html --theme ~/dotfiles/config/marp/ntt.css --pptx --allow-local-files -o ~/Box/oe.issa/03.step研修/提出/事前課題②シート_ＣＤ研_小江一茶.pptx

resize: 
	mkdir -p resized
	for f in *.png; do
	  [ -e "$f" ] || continue
	  magick "$f" -resize '900x900>' "resized/$f"
	done
