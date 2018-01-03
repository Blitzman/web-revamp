---
layout: default
permalink: projects/carnd-term1-p1-lanelines/carnd-term1-p1-lanelines
---

# Finding Lane Lines on the Road

This project is part of the first term of the Udacity Self-Driving Car Nanodegree:
[![Udacity - Self-Driving Car NanoDegree](https://s3.amazonaws.com/udacity-sdc/github/shield-carnd.svg)](http://www.udacity.com/drive)

Code is open-sourced at [GitHub/Blitzman/CarND-LaneLines-P1](https://github.com/Blitzman/CarND-LaneLines-P1).

In this project, we intended to identify lane lines on the road, first in an image, and later in a video stream. Our first goal was to write code including a series of steps (pipeline) that identify and draw the lane lines on a few test images. Once we could successfully identify the lines in an image, we ran the code on a video stream. The next goal was to then refine our pipeline with parameter tuning and by averaging and extrapolating the lines. At last, we tackled the challenge video.

[//]: # (image references)

[image1]: ./writeup_images/image1.png "image1"
[image1_grayscale]: ./writeup_images/image1_grayscale.png "image1_grayscale"
[image1_equalized]: ./writeup_images/image1_equalized.png "image1_equalized"
[image1_graythreshold]: ./writeup_images/image1_graythreshold.png "image1_graythreshold"
[image1_gaussian]: ./writeup_images/image1_gaussian.png "image1_gaussian"
[image1_canny]: ./writeup_images/image1_canny.png "image1_canny"
[image1_roi]: ./writeup_images/image1_roi.png "image1_roi"
[image1_roipoly]: ./writeup_images/image1_roipoly.png "image1_roipoly"
[image1_hough]: ./writeup_images/image1_hough.png "image1_hough"
[image1_fit]: ./writeup_images/image1_fit.png "image1_fit"
[image1_result]: ./writeup_images/image1_result.png "image1_result"
[image2]: ./writeup_images/image2.png "image2"
[image2_result]: ./writeup_images/image2_result.png "image2_result"
[image3]: ./writeup_images/image3.png "image3"
[image3_whitemask]: ./writeup_images/image3_whitemask.png "image3_whitemask"
[image3_yellowmask]: ./writeup_images/image3_yellowmask.png "image3_yellowmask"
[image3_result]: ./writeup_images/image3_result.png "image3_result"
[image4]: ./writeup_images/image4.png "image4"
[image4_result]: ./writeup_images/image4_result.png "image4_result"
[image5]: ./writeup_images/image5.png "image5"
[image5_result]: ./writeup_images/image5_result.png "image5_result"
[image6]: ./writeup_images/image6.png "image6"
[image6_result]: ./writeup_images/image6_result.png "image6_result"

---

## 1. Basic Pipeline Description

In this section we will describe the minimal basic pipeline that meets the expectations and goals of the project. The pipeline itself is implemented by the function `process_image` and it consists of eight steps. That function expects RGB images as input and will produce RGB images with lane lines overlaid in red.

![Input Image][image1]
![Output Image][image1_result]

### 1.1. Grayscale Conversion

The first step of the pipeline converts the RGB input to grayscale in order to make it a suitable input for the Canny edge detection step. Using the provided `grayscale()` helper function (which makes use of `cv2.cvtColor`) we can easily convert the input image to a single 8-bit intensity channel one.

![Grayscale Conversion][image1_grayscale]

### 1.2. Intensity Threshold

The second step is a pre-processing one to segment the lanes using an intensity threshold. Notice that this step works too for yellow lanes since their grayscale intensity is close to white and different enough from the road. We used a helper function `intensity_threshold()` which sets the intensity of any pixel below a specified threshold to 0. By segmenting out any pixel whose intensity is below 200 we achieve the following result.

![Intensity Threshold][image1_graythreshold]

### 1.3. Gaussian Smoothing

Before moving further, we will apply Gaussian smoothing as another pre-processing step to suppress noise and spurious gradients. We found out that a kernel size of 5 is a good choice to smooth over a reasonably good area without being too small or too large. By using the provided `gaussian_blur()` function we get this result.

![Gaussian Smoothing][image1_gaussian]

### 1.4. Canny Edge Detection

After that, we applied the Canny edge detector to generate a binary image to trace out the edges. We used the `canny()` helper function with a `low_threshold` of 50 and a `high_threshold` of 150. Maintaining the recommended 1:3 ratio we were able to achieve good detection results as shown in the following image.

![Canny Edge Detection][image1_canny]

### 1.5. ROI Segmentation

Next, we will filter any edges detected around the periphery that aren't lane lines. In order to do so, we applied a ROI segmentation process, assuming that the lanes will always appear in roughly the same region of the image of the front facing camera. By using the provided helper function `region_of_interest()` we apply a mask to keep a region of the image defined by a polygon formed from a set of vertices, the rest of the image is set to 0 intensity. We used the following vertices `[[(0,imshape[0]),(imshape[1]/2 - 64, imshape[0]/2 + 64), (imshape[1]/2 + 64, imshape[0]/2 +64), (imshape[1],imshape[0])]]` to achieve a reasonably good result.

![ROI Segmentation][image1_roi]
![ROI Poly][image1_roipoly]

### 1.6. Hough Line Detection

Then we operated on those segmented edges to generate an array of line segments using the Hough transform operation. The helper function `hough_lines()` provided us with the needed OpenCV functionality to apply that operation. After testing various configurations we found out that the set of parameters `rho = 4`, `theta = np.pi/180`, `threshold = 10`, `min_line_length = 8`, and `max_line_gap = 16` produces adequate results.

![Hough Line Detection][image1_hough]

### 1.7. Line Fitting

In order to draw a single line on the left and right lanes, we modified the `draw_lines()` to divide the lines into two arrays: one for the left lines and another one for the right ones. Lines are divided based on their X starting point -- if it falls on the left half of the image it will correspond to a left line, otherwise it will correspond to a right one -- and then each array is used to fit a line using `np.poly1d` and `np.polyfit`. As a result, a fitted line is generated for the left lane `f_l` and for the right lane `f_r` separately.

![Line Fitting][image1_fit]

### 1.8. Image Merging

At last, the input image is combined with the fitted lines to generate the annotated output using the helper function `weighted_img()`.

![Image Merging][image1_result]

### 1.9. Results

This pipeline was tested on the provided test images, producing in all cases reasonably good results (including those images with yellow lanes).

![Input Image 1][image1]
![Output Image 1][image1_result]

![Input Image 2][image2]
![Output Image 2][image2_result]

![Input Image 3][image3]
![Output Image 3][image3_result]

![Input Image 4][image4]
![Output Image 4][image4_result]

![Input Image 5][image5]
![Output Image 5][image5_result]

![Input Image 6][image6]
![Output Image 6][image6_result]

It was also successfully tested on the provided videos: white and yellow (click to watch).

{% include youtubeplayer id="pvyCv6XrOyY" %}

{% include youtubeplayer id="qAYoS7JaMnk" %}

## 2. Potential Shortcomings in the Pipeline

* Yellow lines are hard to detect if they are not clearly different from the ground.
* Road surface color variations difficult detection of both yellow and white lines (low contrast).
* Shaky lines in video streams 
* Curved lanes are not well detected nor extrapolated

All these shortcomings render our basic pipeline unable to properly process and obtain annotations for the challenge video (click to play).

{% include youtubeplayer id="GubKeWtd768" %}

### 3. Tackling the Challenge

In this section we will describe the improvements that were implemented to produce good results on the challenge video. That example is particularly difficult because it features both white and yellow lines with road surface color variations, certain steering angle, and many elements in the scene that might confuse the edge and line detectors. In the end, we were able to generate reasonably good results by improving our pipeline with three steps: histogram equalization, white/yellow masking, and outlier filtering.

### 3.1. Histogram Equalization

Histogram equalization is a common pre-processing operation for adjusting image intensities to enhance contrast. This simple operation will help the pipeline tell apart the lanes from the road since low contrast or bad contrast was one of the main problems for the challenge video.

![Grayscale Conversion][image1_grayscale]
![Equalized Histogram][image1_equalized]

### 3.2. White/Yellow HSV Masking

Grayscale intensity thresholding was a good alternative for detecting white lanes and it even worked surprisingly well for yellow lanes on the test images and one of the basic videos. However, for more challenging scenarios as the example we are dealing with, it turns out to be not enough. We replaced that thresholding for a bi-color masking. First, we converted the image to a better color space for differentiating colors, e.g., HSV. After that, we applied our helper function `mask_color_hsv` which makes use of `cv2.inRange` and `cv2.bitwise_and` to generate and apply a mask respectively for a given range in that color space.

After fine-tuning, we found out that the range `[0, 0, 223] - [255, 32, 255]` produced good results for white masking. The range `[20, 100, 100] - [30, 255, 255]` was used for yellow masking.

![Input Image 3][image3]

![Image 3 White Mask][image3_whitemask]
![Image 3 Yellow Mask][image3_yellowmask]

### 3.3. Outlier Filtering

We noticed that some outlier lines were detected despite our efforts. In order to prune them, we applied a slope-based filter, filtering out any line whose slope is greater than `tan(PI/4)` or smaller than `tan(3*PI/4)` (which is a reasonable range for lane slopes. In the following video (click to play) we can observe outliers in green and good lines in red for the challenge video.

{% include youtubeplayer id="eFkr1CV-LCU" %}

After putting everything together, the challenge video presents no problems and both lanes are detected accurately and consistently in every frame (click to play).

{% include youtubeplayer id="X1gYco6lI6A" %}

## 3. Possible Improvements to the Pipeline

* Line averaging through frames. We detected that some lines are shaky because of the little variations that affect the detected edges in different frames. One possible way to overcome this problem would be to average the extrapolated lanes for a reduced window of frames.

* Adaptive ROI using optical flow. When the car approaches curves, the ROI we are using is no longer useful since it extends vertically to the horizon of the picture. Using an adaptive ROI that curves or morphs its vertices based on the optical flow of the video (or car steering) would clearly help when dealing with curves.
