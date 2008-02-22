From webzpt import WebZPTController, web, class_from
import re
import socket

class CountNotConnectToCarter(Exception):
    pass

class student(WebZPTController):
    def __init__(gtid = '900123456', password='a'):
        self.addr = ('localhost', 7272)
        self.sock = socket.socket((socket.AF_INET, socket.SOCK_STREAM))
        self.socket.connect(self.addr)
        if self.socket.send(gtid + "\n") < len(gtid + "\n"): raise CountNotConnectToCarter, "couldn't send gtid"
        if self.socket.send(password+"\n") < len(gtid + "\n"): CountNotConnectToCarter, "couldn't send password"


            
            
