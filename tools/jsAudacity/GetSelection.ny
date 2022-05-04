$nyquist plug-in
$version 4
$type process
$preview linear
$name (_ "GetSelection")
$manpage "GetSelection"
$debugbutton false
$action (_ "GetSelection...")
$author (_ "Jean SUZINEAU")
$release 2.3.0
$copyright (_ "Released under terms of the GNU General Public License version 2")
(setq f (open "C:\\Selection.txt" :direction :output))
(print (get '*selection* 'start) f)
(print (get '*selection* 'end) f)
(close f)
