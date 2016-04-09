# -*- coding: utf-8 -*-  
# 
# Author
# Ismail AKBUDAK
# ismailakbudak.com
# Turkey cities on graph
  
from PyQt4 import QtCore, QtGui
from graph import *

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    def _fromUtf8(s):
        return s
try:
    _encoding = QtGui.QApplication.UnicodeUTF8
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig, _encoding)
except AttributeError:
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig)

# Application UI
class Ui_MainWindow():
     
    def __init__(self):
        self.graph = Graph()  
        self.graph.traceGrowth = False
        self.graph.traceLog = True
        self.graph.traceElection = True
        self.graph.traceElectionVisual = True
        self.graph.readFiles()
        
    def setupUi(self, MainWindow): 
        MainWindow.setObjectName(_fromUtf8("MainWindow"))
        MainWindow.resize(400, 400)
        self.centralwidget = QtGui.QWidget(MainWindow)
        self.centralwidget.setObjectName(_fromUtf8("centralwidget"))
        MainWindow.setWindowTitle(_translate("MainWindow", "Turkey cities on graph - Ismail AKBUDAK", None))
        font = QtGui.QFont()
        font.setStrikeOut(False)
        font.setPointSize(13)
        MainWindow.setFont(font) 

        # Tabs initialized
        self.tabWidget = QtGui.QTabWidget(self.centralwidget)
        self.tabWidget.setGeometry(QtCore.QRect(0, 0, 2000, 2000))
        self.tabWidget.setObjectName(_fromUtf8("tabWidget"))        
        # Tab main initialized
        self.tabMain = QtGui.QWidget()
        self.tabMain.setObjectName(_fromUtf8("tabMain")) 

        # Main - Nodes count label title
        self.labelNodesCount = QtGui.QLabel(self.tabMain)
        self.labelNodesCount.setGeometry(QtCore.QRect(85, 10, 350, 30)) 
        self.labelNodesCount.setObjectName(_fromUtf8("labelNodesCount"))
        self.labelNodesCount.setText(_translate("MainWindow", "Number of Nodes : ", None)) 

        # Main - Draw Graph  button
        self.pushButtonDraw = QtGui.QPushButton(self.tabMain)
        self.pushButtonDraw.setGeometry(QtCore.QRect(85, 90, 200, 30)) 
        self.pushButtonDraw.setObjectName(_fromUtf8("pushButtonDraw"))
        self.pushButtonDraw.setText(_translate("MainWindow", "Draw Graph", None))
        self.pushButtonDraw.clicked.connect(self.draw)
 
        # Main - Close figure  button
        self.pushButtonClearGraph = QtGui.QPushButton(self.tabMain)
        self.pushButtonClearGraph.setGeometry(QtCore.QRect(85, 170, 200, 30)) 
        self.pushButtonClearGraph.setObjectName(_fromUtf8("pushButtonClearGraph"))
        self.pushButtonClearGraph.setText(_translate("MainWindow", "Clear Graph", None))
        self.pushButtonClearGraph.clicked.connect(self.clearGraph)
   
        # Tab settings initialized
        self.tabSettings = QtGui.QWidget()
        self.tabSettings.setObjectName(_fromUtf8("tabSettings"))   
        

        # Tab main initialized
        self.tabNode = QtGui.QWidget()
        self.tabNode.setObjectName(_fromUtf8("tabNode"))

        # Main window
        # Because of dialog exception 
        # MainWindow.setCentralWidget(self.centralwidget)  
        self.tabWidget.setCurrentIndex(0)
        self.tabWidget.addTab(self.tabMain, _fromUtf8(""))
        self.tabWidget.addTab(self.tabSettings, _fromUtf8("")) 
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.tabMain), _translate("MainWindow", "Main Menu", None))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.tabSettings), _translate("MainWindow", "Settings ", None)) 
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

        # Fill with data
        self.fill_fields() 
 
    def draw(self): 
        self.graph.draw()

    def clearGraph(self): 
        self.graph.removeAll()
        self.fill_fields()          
        
    def fill_fields(self): 
        self.set_labels()
    
    def set_labels(self):
        num = len(self.graph.nodes.keys())
        self.labelNodesCount.setText(  "Number of Nodes : %s" % ( str(num) ) ) 
     
class Win(QtGui.QDialog,Ui_MainWindow):
    def __init__(self):
        Ui_MainWindow.__init__(self)
        QtGui.QDialog.__init__(self)
        self.setupUi(self)

# Main application
if __name__ == "__main__":
    import sys 
    app = QtGui.QApplication(sys.argv) 
    MWindow = Win()
    MWindow.show()
    sys.exit(app.exec_())
