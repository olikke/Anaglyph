#pragma once
#include <QObject>
#include <QImage>
#include <opencv2/opencv.hpp>
#include <QtConcurrent>

class AnaglyphVideo : public QObject
{
    Q_OBJECT
public:
    explicit AnaglyphVideo(QObject *parent = nullptr);

    Q_INVOKABLE void setShiftLeft(int value) {shiftLeft=value;}
    Q_INVOKABLE void setAngle(double value) {angle=value;}

signals:
    void newSample(QImage im);
public slots:
    void leftSample(cv::Mat im);
    void rightSample(cv::Mat im);
private:
    cv::Mat left;
    cv::Mat right;
    QImage resultQIM;
    bool leftNew=false;
    bool rightNew=false;
    void timeOut();
    int shiftLeft=0;
    double angle=0.;
};

