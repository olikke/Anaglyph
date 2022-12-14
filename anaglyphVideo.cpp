#include "anaglyphVideo.h"

void AnaglyphVideo::saveScreen(QString name)
{
    if (name.contains("file:///"))
    {
        name.remove(0,7);
    }
    fileName=name;
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
    if (onlyOne) {
        if (isLeft & leftNew) {
            cv::cvtColor(left,left,CV_BGR2RGB);
            resultQIM=QImage((uchar*)left.data, left.cols, left.rows, left.step, QImage::Format_RGB888);
            emit newSample(resultQIM);
            leftNew=false;
            return;
        }
        if (!isLeft & rightNew) {
            cv::cvtColor(right,right,CV_BGR2RGB);
            resultQIM=QImage((uchar*)right.data, right.cols, right.rows, right.step, QImage::Format_RGB888);
            emit newSample(resultQIM);
            rightNew=false;
            return;
        }
        return;
    }

    if (!leftNew | !rightNew) return;
    leftNew=false;
    rightNew=false;
    cv::Mat RGB[3];
    cv::split(left,RGB);
    RGB[0]=cv::Mat::zeros(left.rows,left.cols,CV_8UC1);
    RGB[1]=cv::Mat::zeros(left.rows,left.cols,CV_8UC1);
    merge(RGB,3,left);

    cv::split(right,RGB);
    RGB[2]=cv::Mat::zeros(right.rows,right.cols,CV_8UC1);
    merge(RGB,3,right);

    if (horizontShift>0) {
        left=left(cv::Rect(0,0,left.cols-horizontShift,left.rows));
        right=right(cv::Rect(horizontShift,0,right.cols-horizontShift,right.rows));
    }
    if (horizontShift<0) {
        left=left(cv::Rect(-horizontShift,0,left.cols+horizontShift,left.rows));
        right=right(cv::Rect(0,0,right.cols+horizontShift,right.rows));
    }
    if (verticalShift>0) {
        left=left(cv::Rect(0,0,left.cols,left.rows-verticalShift));
        right=right(cv::Rect(0,verticalShift,right.cols,right.rows-verticalShift));
    }
    if (verticalShift<0) {
        left=left(cv::Rect(0,-verticalShift,left.cols,left.rows+verticalShift));
        right=right(cv::Rect(0,0,right.cols,right.rows+verticalShift));
    }
    if (!qFuzzyIsNull(leftAngle))
        calcTransform(left,leftAngle,Qt::ZAxis);
       /* cv::Mat rotate=cv::getRotationMatrix2D(cv::Point(left.rows/2,left.cols/2),leftAngle,1.);
        cv::warpAffine(left,left,rotate,cv::Size());*/
    if (!qFuzzyIsNull(rightAngle))
        calcTransform(right,rightAngle,Qt::ZAxis);
        /*cv::Mat rotate=cv::getRotationMatrix2D(cv::Point(right.rows/2,right.cols/2),rightAngle,1.);
        cv::warpAffine(right,right,rotate,cv::Size());*/

    if (!qFuzzyIsNull(leftIncline))
        calcTransform(left,leftIncline,Qt::XAxis);

    if (!qFuzzyIsNull(rightIncline))
        calcTransform(right,rightIncline,Qt::XAxis);

    if (!qFuzzyIsNull(leftTurn))
        calcTransform(left,leftTurn,Qt::YAxis);

    if (!qFuzzyIsNull(rightTurn))
        calcTransform(right,rightTurn,Qt::YAxis);

    if (!text.isEmpty()) {
        cv::putText(left,text.toLatin1().constData(),cv::Point(100-textDist/2,100),cv::FONT_HERSHEY_PLAIN,2,cv::Scalar(0,0,255));
        cv::putText(right,text.toLatin1().constData(),cv::Point(100+textDist/2,100),cv::FONT_HERSHEY_PLAIN,2,cv::Scalar(255,255,0));
    }

    cv::Mat result=cv::Mat(right.rows,right.cols,CV_8UC4);

    cv::addWeighted(right, 1, left, 1, 0,result);

    if (!fileName.isEmpty()) {
        cv::imwrite(fileName.toLatin1().constData(),result);
        fileName="";
    }

    if (startRec)
        emit newFrame(result);

    cv::cvtColor(result,result,CV_BGR2RGB);
    resultQIM=QImage((uchar*)result.data, result.cols, result.rows, result.step, QImage::Format_RGB888);
    emit newSample(resultQIM);
}

void AnaglyphVideo::calcTransform(cv::Mat &image, double angle, Qt::Axis axis)
{
    int width=image.cols;
    int height=image.rows;
    //???????????????????? ?????????? ?????????? ???????????????? ???????????? ?????????? QTransform
    //QTransform ?????????????????????????? ???????????????????????? ?????????? (0,0). ???? ???????????? ????????????????:
    //?????? QRect ??(0,0)=(QRect::left+QRect::width/2, QRect::top+QRect::height/2
    QTransform transform=QTransform();
    transform.translate(width/2,height/2);
    transform.rotate(angle,axis);
    transform.translate(-width/2,-height/2);
    QRect srcRect=QRect(0,0,width,height);
    QPolygon polygon=transform.mapToPolygon(srcRect);
    //???????? ???????????????????????????? ?????????? ?????????????? ????????????????????
    std::vector<cv::Point2f> src;
    src.push_back(cv::Point2f(0,0));
    src.push_back(cv::Point2f(width,0));
    src.push_back(cv::Point2f(width,height));
    src.push_back(cv::Point2f(0,height));
    std::vector<cv::Point2f> dst;
    dst.push_back(cv::Point2f(polygon.point(0).x(),polygon.point(0).y()));
    dst.push_back(cv::Point2f(polygon.point(1).x(),polygon.point(1).y()));
    dst.push_back(cv::Point2f(polygon.point(2).x(),polygon.point(2).y()));
    dst.push_back(cv::Point2f(polygon.point(3).x(),polygon.point(3).y()));
    cv::Mat homo=cv::findHomography(src,dst,CV_RANSAC,5.);
    cv::warpPerspective(image,image,homo,cv::Size());
}


