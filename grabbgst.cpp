#include "grabbgst.h"

GstFlowReturn new_sampleA(GstAppSink *appsink, gpointer data)
{
    GrabbGst* app=reinterpret_cast<GrabbGst*>(data);
    GstSample *sample = gst_app_sink_pull_sample(appsink);
    GstBuffer *buffer = gst_sample_get_buffer(sample);
    GstBuffer *appbuffer =  gst_buffer_copy(buffer);
    gst_sample_unref(sample);
    GstMapInfo map;
    gst_buffer_map (appbuffer, &map, GST_MAP_READ);
    QImage img= QImage(map.data, 1920,1080,QImage::Format_RGB32);
    gst_buffer_unmap (appbuffer, &map);
    gst_buffer_unref(appbuffer);
    emit app->newSample(img);
    return GST_FLOW_OK;

}

GrabbGst::GrabbGst(QObject *parent) : QObject(parent)
{
    GError* err=nullptr;
    if (!gst_init_check (nullptr, nullptr, &err))
    {
        qCritical("gst init failed %s\n", err->message);
        exit(EXIT_FAILURE);
    }
    bool allDevicesNeed=true;
     if(allDevicesNeed) {
         for (int i=0; i<10; i++)
             if (QFile("/dev/video"+QString::number(i)).exists())
                 GrabbGst::allDevicesList.push_back("/dev/video"+QString::number(i));
         allDevicesNeed=false;
     }
}

void GrabbGst::play(int numb)
{
    if (numb<0 ||  numb>allDevicesList.count()) return;
    stop();
    dn=numb;
    deviceName=allDevicesList.at(numb);
    if (!QFile(deviceName).exists()) return;
    QString pipelineString ="v4l2src device="+ deviceName+" ! image/jpeg, width=1920, height=1080, framerate=25/1 ! jpegdec ! videoconvert  ! video/x-raw,format=BGRA ! appsink name=AppSink drop=true max-buffers=1 emit-signals=true";
    GError* err=nullptr;
    pipeline = gst_parse_launch(pipelineString.toStdString().c_str(), &err);
    qDebug()<<pipelineString;
    if (!pipeline || err)
    {
        qCritical("gst create pipeline error %s\n",err->message);
        return;
    }
    GstElement *appsink = gst_bin_get_by_name(reinterpret_cast<GstBin*>(pipeline), "AppSink");
    GstAppSinkCallbacks callbacks = { nullptr, nullptr, new_sampleA};
    gst_app_sink_set_callbacks(reinterpret_cast<GstAppSink*>(appsink), &callbacks,this, nullptr);
    gst_element_set_state (pipeline, GST_STATE_PLAYING);

}

void GrabbGst::rec(QString fileName)
{
    stop();
    if (deviceName.isEmpty()) return;


    fileName="/home/olikke/Work/"+QString::number(dn)+".avi";
    QString pipelineString ="v4l2src device="+ deviceName+" ! image/jpeg, width=1920, height=1080, framerate=30/1 ! tee name=videoTee"+
            +" videoTee. ! queue ! avimux ! filesink location=" + fileName+
            "  videoTee. ! queue ! jpegdec !  videoconvert  ! video/x-raw,format=BGRA ! appsink name=AppSink drop=true max-buffers=1 emit-signals=true";
    GError* err=nullptr;
    pipeline = gst_parse_launch(pipelineString.toStdString().c_str(), &err);
    qDebug()<<pipelineString;
    if (!pipeline || err)
    {
        qCritical("gst create pipeline error %s\n",err->message);
        return;
    }
    GstElement *appsink = gst_bin_get_by_name(reinterpret_cast<GstBin*>(pipeline), "AppSink");
    GstAppSinkCallbacks callbacks = { nullptr, nullptr, new_sampleA};
    gst_app_sink_set_callbacks(reinterpret_cast<GstAppSink*>(appsink), &callbacks,this, nullptr);
    gst_element_set_state (pipeline, GST_STATE_PLAYING);
}

void GrabbGst::stop()
{
    if (!pipeline) return;
    qDebug()<<"1";
    gst_element_set_state (pipeline, GST_STATE_NULL);
    qDebug()<<"2";
    if (pipeline) gst_object_unref(reinterpret_cast<GstObject*>(pipeline));
    qDebug()<<"3";
    pipeline=nullptr;
}
