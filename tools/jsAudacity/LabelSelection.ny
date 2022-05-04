;nyquist plug-in
;version 4
;type analyze
;name "Label Selection"

;control labeltext "Label Text" string "" "Label"

(setf duration (- (get '*selection* 'end) (get '*selection* 'start)))
(list (list 0 duration txt))

