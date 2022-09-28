#pragma once

#include <QObject>
#include <opencv2/opencv.hpp>

class GrabOpenCV : public QObject
{
    Q_OBJECT
public:
    explicit GrabOpenCV(int number, QObject *parent = nullptr);
    ~GrabOpenCV();
    Q_INVOKABLE void start(int numb);

signals:
    void newSample(cv::Mat mat);

public slots:
    void execute();

private:
    cv::VideoCapture cap;
    int numb;
};
