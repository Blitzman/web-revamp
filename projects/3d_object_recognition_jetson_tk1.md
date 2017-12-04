---
layout: default
permalink: projects/3d_object_recognition_jetson_tk1
redirect_from:
  - /3dobjrecog-jetsontk1/
---

# Interactive 3D Object Recognition Pipeline on Mobile GPGPU Computing Platforms using Low-cost RGB-D Sensors

{% include youtubeplayer id="h2ovoYiF39Y" %}

[Full Paper on Journal of Real-Time Image Processing](https://link.springer.com/article/10.1007/s11554-016-0607-x)

In this work, we propose the implementation of a 3D object recognition system which will be optimized to operate under demanding time constraints. The system must be robust so that objects can be recognized properly in poor light conditions and cluttered scenes with significant levels of occlusion.

An important requirement must be met: the system must exhibit a reasonable performance running on a low power consumption mobile GPU computing platform (NVIDIA Jetson TK1) so that it can be integrated in mobile robotics systems, ambient intelligence or ambient assisted living applications. The acquisition system is based on the use of color and depth (RGB-D) data streams provided by low-cost 3D sensors like Microsoft Kinect or PrimeSense Carmine.

The resulting system is able to recognize objects in a scene in less than 7 seconds, offering an interactive frame rate and thus allowing its deployment on a mobile robotic platform. Because of that, the system has many possible applications, ranging from mobile robot navigation and semantic scene labeling to human-computer interaction (HCI) systems based on visual information.

## Dataset

A custom 3D dataset was created for evaluating the performance of our proposed system, a detailed view of the dataset can be found [here](/projects/multisensor_dataset).

## Code

In addition, the source code of the system is distributed under an open-source license in the following GitHub repository: [Blitzman/object-recognition](https://github.com/Blitzman/object-recognition).

## Citation

```bibtex
@article{Garcia-Garcia2016,
  title={Interactive 3D object recognition pipeline on mobile GPGPU computing platforms using low-cost RGB-D sensors},
  author={Garcia-Garcia, Alberto and Orts-Escolano, Sergio and Garcia-Rodriguez, Jose and Cazorla, Miguel},
  journal={Journal of Real-Time Image Processing},
  pages={1--20},
  year={2016},
  publisher={Springer}
}
```

