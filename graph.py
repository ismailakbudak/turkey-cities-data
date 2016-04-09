# -*- coding: utf-8 -*-
# Node and graph implementation
# Developer
# Ismail AKBUDAK
# ismailakbudak.com

from matplotlib import pyplot as plt
import matplotlib.cbook as cbook
import matplotlib.image as image

import networkx as nx
import random
from collections import OrderedDict
import pprint
import math
import numpy as np
import json
pp = pprint.PrettyPrinter(indent=4)
 
""" 
Node position class
Args:  
    X: int 
        x coordinate
    Y: int 
        y coordinate
""" 
class Position(object):
    """docstring for Position"""
    def __init__(self, X, Y):
        super(Position, self).__init__()
        self.X = X
        self.Y = Y

""" 
Node class for graph structure 
Args: 
    ID: Integer unique id of node
    CAPACITY: Integer capacity of node
    X: Integer node x coordinate
    Y: Integer node y coordinate
""" 
class Node(object): 
    
    def __init__(self, ID, CAPACITY, X=0, Y=0, CITY_NAME=""):
        self.ID = ID
        self.CITY_NAME = CITY_NAME
        self.CAPACITY = CAPACITY
        self.POSITION = Position(X,Y)
        self.VISITED = False
        self.NAME = 'N:%s'%(str(ID))
        self.SHORT_NAME = 'N:%s'%(str(ID))
        self.COORDINATOR = self
        self.neighbours={}  
        self.log("node initialized..")
    
    def __repr__(self):
        return self.SHORT_NAME

    def __str__(self):
        return "" #self.NAME

    """ 
    Add new node to neighbours
    Args:
        Node object
    Return: 
        Boolean result
        If added True otherwise False   
    """    
    def addNeighbour(self,node):
        if not(self.neighbours.has_key(node.ID)):
            self.neighbours[node.ID]=node
            node.neighbours[self.ID]=self
            self.log("neighbour added..")
            return True
        else:
            self.log("neighbour could not added..")
            self.log("ERROR: key '%s' is exist in '%s'"%(node.ID, self) )
            return False

    """ 
    Remove node from neighbours
    Args:
        Node object
    Return: 
        Boolean result
        If removed True otherwise False   
    """
    def removeNeighbour(self,node):
        if self.neighbours.has_key(node.ID):
            self.neighbours.pop(node.ID)
            node.neighbours.pop(self.ID)
            self.log("neighbour removed..")
            return True
        else:
            self.log("neighbour could not removed..")
            self.log("ERROR: key '%s' is not exist in '%s'"%(node.ID, self) )
            return False


    """ 
    Remove all neighbours
    Args:
        None
    Return: 
        Boolean result
        If removed True otherwise False   
    """         
    def remove(self):
        iterator = self.neighbours.copy()
        for node in iterator.values():
            if not(node.removeNeighbour(self)):
                return False
        self.log("removed all neighbours..")
        return True       

    def log(self, message):
        #print("NODE:: %s"%(message) ) 
        pass

""" 
Graph class
Args: 
    None
""" 
class Graph(object):

    def __init__(self):
        self.nodes={}
        self.positions={}
        self.lastID=0 
        self.cordinatorCount=1
        self.weightValue=1
        self.traceElection=True
        self.traceLog=True 
        self.traceElectionVisual=True
        self.useRandomCapacity=True
        self.log("Graph initialized..")  
            
    """ 
    Add new node to graph 
    Args: 
        node: new node that will add
    Return: 
        Boolean if added True otherwise False
    """ 
    def add(self, node):
        if not(self.nodes.has_key(node.ID)):
            self.nodes[node.ID]=node
            self.lastID += 1
            self.log("node added..")
            return True
        else:
            self.log("node could not added..")
            self.log("ERROR: key '%s' is exist"%(node.ID) )
            return False
    
    """ 
    Remove node from graph
    Args: 
        node: new node that will remove
    Return: 
        None
    """ 
    def remove(self, node):
        node.remove()
        self.nodes.pop(node.ID)
        self.log("node removed..")        
    
    """ 
    Remove all graph nodes 
    Args: 
        None
    Return: 
        None
    """ 
    def removeAll(self):
        self.nodes = {}
        self.positions = {}
        self.lastID=0 
        self.log("all nodes removed..")
    
    """ 
    Connect to nodes eachother
    Args: 
        node1: node object
        node2:  nodes object
    Return: 
        None
    """
    def link(self,node1,node2):
        if node1.addNeighbour(node2):
            self.log("nodes linked..")
            return True
        else:
            return False     

    """ 
    Find distance between two position
    Args: 
        node: Node object
        node2: Node object
    Return: 
        None
    """       
    def findDistance(self, node, node2):
         return round( math.sqrt( math.pow((node.POSITION.X - node2.POSITION.X), 2) + math.pow((node.POSITION.Y - node2.POSITION.Y), 2)), 2) 
       
    """ 
    Draw all nodes with CAPACITY property
    Args: 
        None
    Return: 
        None
    """
    def draw(self):
        self.log("graph is drawing..")
        colors = ["#EFDFBB","orange","lightgreen","lightblue","#FFD300","violet","yellow","#7CB9E8","#E1A95F", "#007FFF","#CCFF00","pink","cyan"]
        
        def find_color(node): 
            return colors[0] 

        def find_length(node, node_neighbour):
             return round( math.sqrt( math.pow((node.POSITION.X - node_neighbour.POSITION.X), 2) + math.pow((node.POSITION.Y - node_neighbour.POSITION.Y), 2)), 2)
        
        graph = nx.DiGraph()
        node_size = []
        for node in self.nodes.values():
            node_size.append(100*node.CAPACITY)    
            graph.add_node(node)
            for node_neighbour in node.neighbours.values():
                graph.add_edge(node, 
                                node_neighbour,
                                weight=find_length(node, node_neighbour), 
                                color=find_color(node_neighbour) )
        node_colors = map(find_color, graph.nodes())

        if len(self.nodes) > 1:
            edges=[]
            edge_colors="yellow"    
            # edges,edge_colors = zip(*nx.get_edge_attributes(graph,'color').items()) 
        else:
            edges=[]
            edge_colors="yellow"    

        im = image.imread('web/public/turkey.gif') 
        plt.imshow(im, aspect='auto', extent=(25.9,45,35.6,42.25), alpha=0.9, zorder=-1)

        G=nx.grid_2d_graph(1,1)
        plt.subplot(111)     
        labels = nx.get_edge_attributes(graph,'weight')
        nx.draw_networkx_edge_labels(
            graph,
            self.positions,
            edge_labels=labels,  
            font_family='ubuntu', 
            edgelist=edges,
            edge_color=edge_colors
        )
        nx.draw(graph,
                self.positions,
                with_labels=True,
                font_size=8,
                node_size=950,#node_size,
                font_family='ubuntu',
                font_color='red',
                node_color=node_colors, 
                edgelist=edges,
                edge_color=edge_colors, 
                width=0.4) 
        plt.axis('on')
        plt.grid('on')    
        plt.show()  
        
    """ 
    Read nodes and edges from file 
    Args: 
        None
    Return: 
        None
    """
    def readFiles(self):
        #nodes.txt => node_id capacity
        #edges.txt => node_id node_id 
        try:
            with open('./data/cities.json') as data_file:    
                cities = json.load(data_file)
             
            for city in cities: 
                ID =  int(city["id"])
                CITY_NAME =  city["name"]
                X = float(city["longitude"])
                Y = float(city["lattitude"])
                CAPACITY = 1
                node = Node(ID, CAPACITY, X, Y, CITY_NAME)
                self.add(node)
                self.positions[node] = (X,Y) 

            # f = open('edges.txt','r')
            # lines = f.readlines()
            # for line in lines:
            #     content = line.strip().split()
            #     if len(content) == 2:
            #         id1 = int(content[0])
            #         id2 = int(content[1])
            #         if self.nodes.has_key(id1) and self.nodes.has_key(id2):
            #             node1 = self.nodes[ id1 ]
            #             node2 = self.nodes[ id2 ]
            #             self.link( node1, node2 )
            #         else:
            #             if not(self.nodes.has_key(id1)):
            #                 self.log("ERROR: key '%s' is not exist"%(id1) )
            #             if not(self.nodes.has_key(id2)):
            #                 self.log("ERROR: key '%s' is not exist"%(id2) )
            self.log('Files readed successfully..')
        except Exception, error:
            self.log('Files could not read..')
            self.log('ERROR: %s' % error)   

    """ 
    Log messages 
    Args: 
        message: string first message
    Return: 
        None
    """
    def log(self, message):
        if self.traceLog:  
            print("GRAPH:: %s"%(message) )

    """ 
    Log messages for prety print array
    Args: 
        message: string first message
        array: array for prety print
        is_write: Boolean default value is True
    Return: 
        None
    """
    def log_pp(self, message, array, is_write=True ):
        if is_write:
             print("GRAPH:: %s"%(message) )
             pp.pprint(array)              


# Main application
if __name__ == "__main__":
    graph = Graph() 
    graph.readFiles()
    graph.draw()