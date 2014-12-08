(send *dxl-armed-turtlebot* :reset-pose) ;;初期化
(when (boundp '*ri*)
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 5000)
  (send *ri* :wait-interpolation))
(objects (list *dxl-armed-turtlebot*))
(send *dxl-armed-turtlebot* :gripper :arm :angle-vector #f(50))
(send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 1000 :gripper-controller)
(send *ri* :wait-interpolation :gripper-controller)

(setq step 10)
(setq *pose* (float-vector 350 0 0))

(defun cb-controller (msg);;コールバック
  (progn
    (setq bt (send msg :buttons))
	(if (= (elt bt 4) 1);;上キー
		(progn
		  (setq *pose* (v+ (float-vector  step 0 0) *pose*))
		  (send *dxl-armed-turtlebot* :inverse-kinematics
				(make-coords :pos *pose*
							 :rotation-axis :z :revert-if-fail nil))));;前進
	(if (= (elt bt 5) 1);;右キー
		(progn
		  (setq *pose* (v+ (float-vector 0 0 step) *pose*))
		  (send *dxl-armed-turtlebot* :inverse-kinematics
				(make-coords :pos *pose*
							 :rotation-axis :z :revert-if-fail nil))));;右
	(if (= (elt bt 6) 1);;下キー
		(progn
		  (setq *pose* (v+ (float-vector -step 0 0) *pose*))
			(send *dxl-armed-turtlebot* :inverse-kinematics
				  (make-coords :pos *pose*
							   :rotation-axis :z :revert-if-fail nil))));;後退
	(if (= (elt bt 7) 1);;左キー
		(progn
		  (setq *pose* (v+ (float-vector 0 0 -step) *pose*))
		  (send *dxl-armed-turtlebot* :inverse-kinematics
				(make-coords :pos *pose*
							 :rotation-axis :z :revert-if-fail nil))));;左
	(if (= (elt bt 8) 1);;L2
		(progn
		  (setq *pose* (v+ (float-vector 0 step 0) *pose*))
		  (send *dxl-armed-turtlebot* :inverse-kinematics
				(make-coords :pos *pose*
							 :rotation-axis :z :revert-if-fail nil))));;上昇
	(if (= (elt bt 9) 1);;R2
		(progn
		  (setq *pose* (v+ (float-vector 0 -step 0) *pose*))
		  (send *dxl-armed-turtlebot* :inverse-kinematics
				(make-coords :pos *pose*
							 :rotation-axis :z :revert-if-fail nil))));;下降
	;;以下二つの動作はアームのハンドグリッパなので起動しないorエラーの恐れ大
	(if (= (elt bt 13) 1);;circle-button
		(send *ri* :start-grasp));;つかむ
	(if (= (elt bt 14) 1);;cross-button
		(send *ri* :stop-grasp));;はなす
	;;もしここまででエラーが出て動作しないなら以下の順運動学を実行
	(if (= (elt bt 12) 1);;triangle-button
		(send (send *dxl-armed-turtlebot* :arm_joint6)
			  :joint-angle 30));;30度回転
	(if (= (elt bt 15) 1);;square-button
		;;	      (send (send *dxl-armed-turtlebot* :arm_joint6)
;;		    :joint-angle -30));;-30度回転
		(print 1))
	;;ここも起動しないなら動作部分だけコピペして実行してみる。それで起動したらおそらくコールバック出来てない。
	(send *ri* (send 

	))

(ros::subscribe "/joy" sensor_msgs::Joy #'cb-controller)

(while (ros::ok)
  (ros::spin-once)
  (ros::sleep))
