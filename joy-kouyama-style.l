(load "package://roseus/test/joy.l")
(load "package://dxl_armed_turtlebot/euslisp/dxl-armed-turtlebot-interface.l")
(load "package://daisya_euslisp_tutorials/euslisp/daisya.l")
(load "package://daisya_euslisp_tutorials/euslisp/irteusext.l")


(ros::load-ros-manifest "roseus")
(ros::load-ros-manifest "sensor_msgs")
(ros::load-ros-manifest "kobuki_msgs")

(ros::roseus "tekito")


;(if (not (boundp '*irtviewer*))
;    (setq *irtviewer* (make-irtviewer)))
(dxl-armed-turtlebot-init)
;(init-ps3joy)
;(sample-ps3joy)
;(send *dxl-armed-turtlebot* :gripper :angle-vector #f(50))
;(send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 1000 :gripper-controller)
;(send *ri* :wait-interpolation :gripper-controller)

 #|******************************
  描画周りの初期起動処理
********************************|#
(if (not (boundp '*irtviewer*))
    (setq *irtviewer* (make-irtviewer)))
(setq *daisya* (instance daisyaclass :init)) 
(send *daisya* :reset-pose)
(objects (list *daisya*))


;;逆運動学が解きやすい初期姿勢に変更
(setq robot *daisya*)
(send robot :reset-pose)
;(when (boundp '*ri*)
;  (send *ri* :angle-vector (send robot :angle-vector) 5000)
;  (send *ri* :wait-interpolation))
;(objects (list robot))


(defclass ctrl-class
  :super propertied-object
  :slots ())
(defmethod ctrl-class
(:init ()
	   (setq goal-endcoords
			 (make-cascoords :pos (send (send robot :arm :end-coords 
											  :copy-worldcoords) :worldpos)))
	   (ros::subscribe "/joy" sensor_msgs::Joy #'send self :cb-controller))
(:cb-controller (msg)
  (progn
;  (ros::rate 10)
	(print "cb-controller hajime")
	(setq bt (send msg :buttons))
	(print (elt bt 13))
	(if (= (elt bt 13) 1)
		(progn
		  (print ";; circle button pressed")
		  ;;(send *ri* :start-grasp)
		  )
	  (if (= (elt bt 14) 1)
		  (progn
			(print ";; cross button pressed")
			;;(send *ri* :stop-grasp)
			)))
   (if (= (elt bt 15) 1)
	   (progn
		 (print ";; square button pressed")
		 (send goal-endcoords :locate (float-vector 0 0 10)))
	 nil)
;   (if (= (send msg :triangle-button) 1)
;       (print ";; triangle button pressed"))
;   (if (= (send msg :l1-button) 1)
;       (print ";; l1 button pressed"))
;   (if (= (send msg :l2-button) 1)
;       (print ";; l2 button pressed"))
;   (if (= (send msg :r1-button) 1)
;       (print ";; r1 button pressed"))
;   (if (= (send msg :r2-button) 1)
;       (print ";; r2 button pressed"))
;   (if (= (send msg :pairing-button) 1)
;       (print ";; ps button pressed"))
;;   (if (= (send msg :up-button) 1)
;       (print ";; up button pressed"))
;   (if (= (send msg :down-button) 1)
;       (print ";; down button pressed"))
;   (if (= (send msg :left-button) 1)
;       (print ";; left button pressed"))
;   (if (= (send msg :right-button) 1)
;       (print ";; right button pressed"))
;   (if (= (send msg :pairing-button) 1)
;       (print ";; ps button pressed"))
;   (if (= (send msg :start-button) 1)
;       (print ";; start button pressed"))
;   (if (= (send msg :select-button) 1)
;       (print ";; select button pressed"))
;   (if (= (send msg :l3-button) 1)
;       (print ";; l3 button pressed"))
;   (if (= (send msg :r3-button) 1)
;       (print ";; r3 button pressed"))
)))
(setq m (instance ctrl-class :init))


(do-until-key
  (ros::spin-once)
;  (ros::sleep)
)
