#pragma once

#include <QObject>
#include <opencv2/opencv.hpp>

class WriteOpenCV : public QObject
{
    Q_OBJECT
public:
    explicit WriteOpenCV(QObject *parent = nullptr): QObject(parent) {}
    ~WriteOpenCV();

    Q_PROPERTY(bool isRecord READ getIsRecord NOTIFY isRecordChanged)
    bool getIsRecord() {return isRecord;}
    Q_INVOKABLE void start(QString name);
    Q_INVOKABLE void stop();


signals:
    void isRecordChanged();
    void startRecord(bool start);

public slots:
    void newFrame(cv::Mat frame);

private:
        cv::VideoWriter* writer;
        int width=1920;
        int height=1080;
        bool isRecord=false;
};
