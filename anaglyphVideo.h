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
};

