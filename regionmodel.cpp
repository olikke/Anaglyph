#include "regionmodel.h"

RegionModel::RegionModel(QObject *parent): QAbstractListModel(parent)
{
    qRegisterMetaType<PointState>("PointState");
    qmlRegisterUncreatableType<PointStateClass>("com.GlobalEnum", 1, 0, "PointState", "");

}

int RegionModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())  return 0;
    return m_data.size();
}

QVariant RegionModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    switch (role){
    case StateRole:
        return QVariant(m_data.at(index.row()).state);
    case  PosRole:
        return QVariant(m_data.at(index.row()).point);
     case IDRole:
        return QVariant(m_data.at(index.row()).id);
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> RegionModel::roleNames() const
{
    QHash<int, QByteArray> roles = QAbstractListModel::roleNames();
    roles[StateRole] = "state";
    roles[PosRole]="pos";
    roles[IDRole]="id";
    return roles;
}
