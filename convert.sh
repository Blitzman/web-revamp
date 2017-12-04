rm -rf _site_converted
mkdir _site_converted
cp -r _site/* _site_converted/.
find ./_site -name "*.html" -type f -exec iconv -t iso-8859-1 -f utf-8 "{}" -o _site_converted/"{}" \;
