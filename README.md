# Caffe_visualizing
A GUI Tool created on Matlab for visualizing the feature maps of Alexnet(vgg16) trained on Caffe.

# Dependence for GUI
1.Caffe

2.activate matlab interface

3.Matlab 2014B

# attention
In the file 'convolution_vis.m'

Don't forget to change mean_file and label_file to your own file address


# Running the tool 
1.run 'convolution_vis.m' in Matlab

2.click 'Load Network'button to upload deploy.prototxt.

3.click 'Load CaffeModel'button to upload caffemodel file trained on caffe.

After Step 2 and step 3 successing uploading, layer names of alexnet will be shown on GUI


4.click 'Load test picture' button to upload test picture.
5.click layer name and its feature map will appeared.
