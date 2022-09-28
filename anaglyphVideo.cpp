#include "anaglyphVideo.h"

AnaglyphVideo::AnaglyphVideo(QObject *parent) : QObject(parent)
{
}

void AnaglyphVideo::leftSample(cv::Mat im)
{
    left=im.clone();
    leftNew=true;
    timeOut();
}

void AnaglyphVideo::rightSample(cv::Mat im)
{
    right=im.clone();
    rightNew=true;
    timeOut();
}

void AnaglyphVideo::timeOut()
{
    if (!leftNew | !rightNew) return;
    leftNew=false;
    rightNew=false;
    cv::Mat left1=cv::Mat(left.rows,left.cols,CV_8UC3);
    cv::Mat RGB[3];
    cv::split(left,RGB);
    RGB[0]=cv::Mat::zeros(left.rows,left.cols,CV_8UC1);
    RGB[1]=cv::Mat::zeros(left.rows,left.cols,CV_8UC1);
    merge(RGB,3,left1);

    cv::Mat right1=cv::Mat(right.rows,right.cols,CV_8UC3);
    cv::split(right,RGB);
    RGB[2]=cv::Mat::zeros(right.rows,right.cols,CV_8UC1);
    merge(RGB,3,right1);

    cv::Mat result=cv::Mat(right.rows,right.cols,CV_8UC4);

   cv::addWeighted(right1, 0.5, left1, 0.5, 0,result);

   cv::Ptr<cv::CLAHE> clahe = cv::createCLAHE();
   clahe->setClipLimit(2);
   cv::split(result,RGB);
//   QList<cv::Mat> RGB1;

//   RGB1.push_back(RGB[0]);
//   RGB1.push_back(RGB[1]);
//   RGB1.push_back(RGB[2]);

//   QList<cv::Mat> RGB2=QtConcurrent::blockingMapped<QList<cv::Mat>>(RGB1,[&clahe](const cv::Mat &RGB){/*cv::Mat RGB1; */clahe->apply(RGB,RGB); return RGB;});

//   QtConcurrent::mappedReduced(RGB1,
//           [](const QImage &image) {
//               return image.scaled(size, size);
//           },
//           addToCollage
//      ).results();


   clahe->apply(RGB[0],RGB[0]);
   clahe->apply(RGB[1],RGB[1]);
   clahe->apply(RGB[2],RGB[2]);
   merge(RGB,3,result);

   cv::cvtColor(result,result,CV_BGR2RGB);

   resultQIM=QImage((uchar*)result.data, result.cols, result.rows, result.step, QImage::Format_RGB888);

   emit newSample(resultQIM);


}
