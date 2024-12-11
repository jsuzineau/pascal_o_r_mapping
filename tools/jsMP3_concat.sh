#https://trac.ffmpeg.org/wiki/Concatenate
for f in *.mp3; do echo "file '$f'" >> mylist.txt; done
ffmpeg -f concat -safe 0 -i mylist.txt -c copy $(basename $(pwd)).mp3