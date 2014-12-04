#!/usr/bin/env roseus
(ros::load-ros-manifest "roseus")
(ros::load-ros-manifest "kobuki_msgs")
(ros::roseus "listener")

;(load "package://turtleboteus/euslisp/turtlebot-interface.l")
(load "package://dxl_armed_turtlebot/euslisp/dxl-armed-turtlebot-interface.l")

(dxl-armed-turtlebot-init)
(send *dxl-armed-turtlebot* :gripper :arm :angle-vector #f(50))
(send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector)
	  1000 :gripper-controller)
(send *ri* :wait-interpolation :gripper-controller)


(defclass bump-cb-class
  :super propertied-object
  :slots())
(defmethod bump-cb-class
  (:init () 
		 (ros::subscribe "/mobile_base/events/bumper" kobuki_msgs::BumperEvent #'send self :cb-bump))
  (:cb-bump (msg) ;把持する
			(setq gFlag (- 1 (send msg :state)))
			(if gFlag
				(send *ri* :start-grasp)
			  (send *ri* :stop-grasp))))
(setq m (instance bump-cb-class :init))
(setq gFlag 0)

(do-until-key
 (ros::spin-once)
 )

