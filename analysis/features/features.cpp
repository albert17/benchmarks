#include <iostream>
#include <opencv2/core/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/features2d.hpp>
#include <sys/time.h>
#include <string.h>

#define N_TIMES 1

using namespace std;
using namespace cv;

vector<KeyPoint> keypoints;
Mat descriptors;

int process(const char * path){
    Mat img = imread(path, IMREAD_COLOR);
    Mat tmp;
    struct timeval t1,t2;
    double diff;
    gettimeofday (&t1, NULL); 
    for(int i = 0; i < N_TIMES; i++) {
    	cvtColor(img, tmp, COLOR_BGR2GRAY);
	Ptr<FeatureDetector> fd;
        fd = ORB::create();
    	fd->detectAndCompute(tmp,noArray(),keypoints,descriptors);
    }
    gettimeofday (&t2, NULL);
    diff = (t2.tv_sec - t1.tv_sec) * 1000000.0;
    diff += (t2.tv_usec - t1.tv_usec);
    cout << "Time(us): " << diff/N_TIMES << endl;
    return 0;
}

int main(int argc, const char *argv[])
{
    if (argc != 2)
    {
        cout << "Uso: ./features img" << endl;
        return 1;
    }
    return process(argv[1]);
}
