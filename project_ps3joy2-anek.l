(send *dxl-armed-turtlebot* :reset-pose) ;;初期化
(when (boundp '*ri*)
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 5000)
  (send *ri* :wait-interpolation))
(objects (list *dxl-armed-turtlebot*))
(send *dxl-armed-turtlebot* :gripper :arm :angle-vector #f(50))
(send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 1000 :gripper-controller)
(send *ri* :wait-interpolation :gripper-controller)

(setq step 10)
(setq init-pose (float-vector 350 0 0))

(defun cb-controller (msg);;コールバック
  (progn
    (setq bt (send msg :buttons))
	  (if (= (elt bt 4) 1);;上キー
	      (send *dxl-armed-turtlebot* :inverse-kinematics
		    (make-coords :pos (v+ (float-vector step 0 0) init-pose)
		    :rotation-axis :z :revert-if-fail nil));;前進
	  (if (= (elt bt 5) 1);;右キー
	      (send *dxl-armed-turtlebot* :inverse-kinematics
		    (make-coords :pos (float-vector 0 -10 0))
		    :rotation-axis :z :revert-if-fail nil));;右
	  (if (= (elt bt 6) 1);;下キー
	      (send *dxl-armed-turtlebot* :inverse-kinematics
		    (make-coords :pos (float-vector -10 0 0))
		    :rotation-axis :z :revert-if-fail nil));;後退
	  (if (= (elt bt 7) 1);;左キー
	      (send *dxl-armed-turtlebot* :inverse-kinematics
		    (make-coords :pos (float-vector 0 10 0))
		    :rotation-axis :z :revert-if-fail nil));;左
	  (if (= (elt bt 10) 1);;L1
	      (send *dxl-armed-turtlebot* :inverse-kinematics
		    (make-coords :pos (float-vector 0 0 10))
		    :rotation-axis :z :revert-if-fail nil));;上昇
	  (if (= (elt bt 11) 1);;R1
	      (send *dxl-armed-turtlebot* :inverse-kinematics
		    (make-coords :pos (float-vector 0 0 -10))
		    :rotation-axis :z :revert-if-fail nil));;下降
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
	  ))

(ros::subscribe "/joy" sensor_msgs::Joy #'cb-controller)

(while (ros::ok)
  (ros::spin-once)
  (ros::sleep))
