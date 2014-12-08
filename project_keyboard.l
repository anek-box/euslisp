  (send *dxl-armed-turtlebot* :reset-pose) ;;初期化
	(when (boundp '*ri*)
	  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 5000)
	  (send *ri* :wait-interpolation))
	(objects (list *dxl-armed-turtlebot*))

(defun ik-demo
(warn ";; if stop, then enter e~%")
(warn ";; h:left, j:down, k:up, l:right, f:forwaed, b:bacl~%")
(warn ";; n:grasp, m:non-grasp, q:rotate1, w:rotate2")
  (let (w)
    (while t
      (setq w (read-line))
      (cond
       ((equal w "e")
	(return-from nil))
       ((equal w "f");;上キー
	(send *dxl-armed-turtlebot* :inverse-kinematics
	      (make-coords :pos (float-vector 10 0 0))
	      :rotation-axis :z));;前進
       ((equal w "l");;右キー
	(send *dxl-armed-turtlebot* :inverse-kinematics
	      (make-coords :pos (float-vector 0 -10 0))
	      :rotation-axis :z));;右
       ((equal w "b");;下キー
	(send *dxl-armed-turtlebot* :inverse-kinematics
	      (make-coords :pos (float-vector -10 0 0))
	      :rotation-axis :z));;後退
       ((equal w "h");;左キー
	(send *dxl-armed-turtlebot* :inverse-kinematics
	      (make-coords :pos (float-vector 0 10 0))
	      :rotation-axis :z));;左
       ((equal w "k");;L1
	(send *dxl-armed-turtlebot* :inverse-kinematics
	      (make-coords :pos (float-vector 0 0 10))
	      :rotation-axis :z));;上昇
       ((equal w "j");;R1
	(send *dxl-armed-turtlebot* :inverse-kinematics
	      (make-coords :pos (float-vector 0 0 -10))
	      :rotation-axis :z));;下降
       ;;以下二つの動作はアームのハンドグリッパなので起動しないorエラーの恐れ大
       ((equal w "n");;circle-button
	(send *ri* :start-grasp));;つかむ
       ((equal w "m");;cross-button
	(send *ri* :stop-grasp));;はなす
       ;;もしここまででエラーが出て動作しないなら以下の順運動学を実行
       ((equal w "q");;triangle-button
	(send (send *dxl-armed-turtlebot* :arm_joint6)
	      :joint-angle 30));;30度回転
       ((equal w "w");;square-button
	(send (send *dxl-armed-turtlebot* :arm_joint6)
	      :joint-angle -30));;-30度回転
       ;;ここも起動しないなら動作部分だけコピペして実行してみる。それで起動したらおそらくコールバック出来てない。
       ((not w))
       (t
	(warn ";; no such command~%")))
)))