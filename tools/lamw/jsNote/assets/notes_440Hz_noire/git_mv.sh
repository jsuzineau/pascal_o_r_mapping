find ./ -type f -name '*2.mp3' -exec sh -c 'git mv "$0" "${0/2.mp3/1.mp3}"' {} \;
find ./ -type f -name '*3.mp3' -exec sh -c 'git mv "$0" "${0/3.mp3/2.mp3}"' {} \;
find ./ -type f -name '*4.mp3' -exec sh -c 'git mv "$0" "${0/4.mp3/3.mp3}"' {} \;
find ./ -type f -name '*5.mp3' -exec sh -c 'git mv "$0" "${0/5.mp3/4.mp3}"' {} \;
find ./ -type f -name '*6.mp3' -exec sh -c 'git mv "$0" "${0/6.mp3/5.mp3}"' {} \;

notes_432Hz_noire
notes_440Hz_noire

find notes_432Hz_noire/ -type f -name '*2.mp3' -exec sh -c 'git mv "$0" "${0/2.mp3/1.mp3}"' {} \;
find notes_432Hz_noire/src/ -type f -name '*2.mscz' -exec sh -c 'git mv "$0" "${0/2.mscz/1.mscz}"' {} \;
find notes_440Hz_noire/src/ -type f -name '*2.mscz' -exec sh -c 'git mv "$0" "${0/2.mscz/1.mscz}"' {} \;


find notes_432Hz_noire/ -type f -name '*3.mp3' -exec sh -c 'git mv "$0" "${0/3.mp3/2.mp3}"' {} \;
find notes_432Hz_noire/src/ -type f -name '*3.mscz' -exec sh -c 'git mv "$0" "${0/3.mscz/2.mscz}"' {} \;
find notes_440Hz_noire/src/ -type f -name '*3.mscz' -exec sh -c 'git mv "$0" "${0/3.mscz/2.mscz}"' {} \;


find notes_432Hz_noire/ -type f -name '*4.mp3' -exec sh -c 'git mv "$0" "${0/4.mp3/3.mp3}"' {} \;
find notes_432Hz_noire/src/ -type f -name '*4.mscz' -exec sh -c 'git mv "$0" "${0/4.mscz/3.mscz}"' {} \;
find notes_440Hz_noire/src/ -type f -name '*4.mscz' -exec sh -c 'git mv "$0" "${0/4.mscz/3.mscz}"' {} \;


find notes_432Hz_noire/ -type f -name '*5.mp3' -exec sh -c 'git mv "$0" "${0/5.mp3/4.mp3}"' {} \;
find notes_432Hz_noire/src/ -type f -name '*5.mscz' -exec sh -c 'git mv "$0" "${0/5.mscz/4.mscz}"' {} \;
find notes_440Hz_noire/src/ -type f -name '*5.mscz' -exec sh -c 'git mv "$0" "${0/5.mscz/4.mscz}"' {} \;


find notes_432Hz_noire/ -type f -name '*6.mp3' -exec sh -c 'git mv "$0" "${0/6.mp3/5.mp3}"' {} \;
find notes_432Hz_noire/src/ -type f -name '*6.mscz' -exec sh -c 'git mv "$0" "${0/6.mscz/5.mscz}"' {} \;
find notes_440Hz_noire/src/ -type f -name '*6.mscz' -exec sh -c 'git mv "$0" "${0/6.mscz/5.mscz}"' {} \;







