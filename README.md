# Computer Vision Benchmark
This repository contains a benchmark composed for two Computer Vision algorithms: ORB & CNNs. Moreover, it contains tools to measure his execution using Hardware Counters.

## Dependencies
* [Caffe](https://github.com/BVLC/caffe)
* [OpenCV](https://github.com/opencv/opencv)
* [PerfTools](https://perf.wiki.kernel.org/index.php/Main_Page)

### With hardware counters
* Edit "./analysis/cnn/Makefile" paths
* Edit "./analysis/features/Makefile" paths
```sh
$ cd analysis
$ ./perf.sh -h (see options)
```

### Without hardware counters
#### ORB
```sh
* Edit "./analysis/features/Makefile" paths
$ cd analysis/features 
$ make
$ ./features (see options)
```
#### CNN
* Edit "./analysis/cnn/Makefile" paths
```sh
$ cd analysis/cnn
$ make
$ ./classification (see options)
```
## Platforms
#### CNN
This software has been tested in Ubuntu 14.04, Ubuntu16.04, and CentOS 6.1

