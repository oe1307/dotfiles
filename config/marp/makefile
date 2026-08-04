view:
	(sleep 1; open -a "Google Chrome" http://localhost:8080/_marp.md) & marp -s . --html --theme ~/dotfiles/config/marp/ntt.css

pptx:
	exec marp _marp.md --html --theme ~/.config/marp/ntt.css --pptx --allow-local-files

pdf:
	exec marp _marp.md --html --theme ~/.config/marp/ntt.css --pdf --allow-local-files
