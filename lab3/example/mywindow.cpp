#include "mywindow.h"

/* Class Constructor */
MyWindow::MyWindow(QWidget *parent) : QWidget(parent)
{
	// 初始化變數
	stroke.clear();
    lines.clear();
    painting = false;

	// 主視窗
    setWindowTitle("Example");
    resize(500, 580);
	setStyleSheet("background-color:#424242;");

    /* OK 按鈕 */
	conf_btn = new QPushButton("OK",this); //按鈕名字
	conf_btn->setStyleSheet(
        "QPushButton{border: 2px solid #95A5A6;border-radius:10px;color:rgb(0,0,0);background-color:rgb(195,195,195)}"); //按鈕樣式
    conf_btn->setFont(QFont("Courier", 20, QFont::Bold)); //按鈕字體
	conf_btn->setGeometry(50, 370, 80, 80); //按鈕位置及大小
	connect(conf_btn, SIGNAL(clicked()), this, SLOT(ConfirmButton_clicked())); //點擊按鈕後會呼叫ConfirmButton_clicked函式
	
    /* Clear 按鈕 */
	clr_btn = new QPushButton("Clear",this);
	clr_btn->setStyleSheet(
        "QPushButton{border: 2px solid #95A5A6;border-radius:10px;color:rgb(0,0,0);background-color:rgb(195,195,195)}");
    clr_btn->setFont(QFont("Courier", 20, QFont::Bold));
	clr_btn->setGeometry(150, 370, 80, 80);
	connect(clr_btn, SIGNAL(clicked()), this, SLOT(ClearButton_clicked()));	
}

/* 將繪圖框存成jpg */
void MyWindow::ConfirmButton_clicked()
{
	// 選取存圖範圍
	QPixmap qpx;
    QImage img = qpx.grabWidget(this, 50, 50, 280, 280).toImage();	
    
    img.save(img_name, "jpg");
	update();
}

/* 清除畫框 */
void MyWindow::ClearButton_clicked()
{
	stroke.clear();	// 清除當前軌跡
    lines.clear();	// 清除畫過的位置
    painting = false;
    update();
}

void MyWindow::mousePressEvent(QMouseEvent* event)
{
    /* 畫筆只能落在此範圍: 325>x>55 && 325>y>55 */
	if(event->x()>55 && event->x()<325 && event->y()>55 && event->y()<325)
    {    
        painting = true;
        stroke.push_back(event->pos());	//存下落筆座標
    }
    update();
}

void MyWindow::mouseMoveEvent(QMouseEvent* event)
{
	/* 只有在滑鼠按下後才紀錄鼠標移動過的座標 */
	if(event->x()>55 && event->x()<325 && event->y()>55 && event->y()<325 && painting)
	{
        stroke.push_back(event->pos());
    	update();
	}
}

void MyWindow::mouseReleaseEvent(QMouseEvent*)
{
	/* 按下滑鼠後鬆開會將畫過的軌跡存在畫布上，並清空軌跡 */
	if(painting)
    {    
        painting = false;        
        lines.push_back(stroke);
        stroke.clear();  
    }
    update();
}

void MyWindow::paintEvent(QPaintEvent*)
{
	// 設定畫筆樣式
	QPainter painter(this);
	painter.setFont(QFont("Arial", 10));
	painter.setBrush(Qt::white);
	painter.setPen(QPen(QColor("#FFFFFF")));

	// 建立畫框範圍
	painter.drawRect(49, 49, 282, 282);

	// 設定畫筆樣式
	painter.setPen(QPen(Qt::black, 18));

	// 繪出畫過的位置
	for(int i=0; i<lines.size(); i++) {
		for(int j=0; j<lines[i].size(); ++j)
			painter.drawPoint(lines[i][j].x(), lines[i][j].y());
   	}
	
	// 繪出當前落筆後的軌跡
	for(int i=0; i<stroke.size(); i++)
        painter.drawPoint(stroke[i].x(), stroke[i].y());	
}