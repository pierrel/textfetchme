from webzpt import WebZPTController, web
import re
import socket



urls = (
    '/login', 'login',
    '/threads', 'threads',
    '/schedule', 'schedule')

class CouldNotConnectToCarter(Exception): 
    pass


class login(WebZPTController):
    pass

class threads(WebZPTController):
    pass

class schedule(WebZPTController):
    '''
    Change the GET method if you are going to implement
    any of the above controllers
    '''
    def GET(self):
        print self.view(partials=(student(),)) #The trailing ',' is necessary for it to be understood as a tuple when it has only one element

class student(WebZPTController):
    '''
    This is the class you will be dealing with
    check look for student.zpt in the views directory
    for an example of using it.
    '''
    def __init__(self, gtid = '900123456', password='a'):
        '''
        Default gtid and password is the correct combination
        '''
        self.addr = ('localhost', 7272)
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.connect(self.addr)
        if self.socket.send(gtid + "\n") < len(gtid)-1: raise CountNotConnectToCarter, "couldn't send gtid"
        if self.socket.send(password+"\n") < len(password)-1: raise CountNotConnectToCarter, "couldn't send password"

        self.socket.send("name\n")
        self.name = self.socket.recv(1024).replace("0\t", '')
        
        self.socket.send("create pl-embodimentintelligence\n")
        self.socket.recv(1024)
        self.socket.send("switch pl-embodimentintelligence\n")
        self.socket.recv(1024)

    def plan(self):
        plan_list = []
        self.socket.send("plan\n")
        plan = self.socket.recv(100000)

        plan_arr = plan[2:].split("\\") #starts with "0\t", which is just the return code, not important now
        #return plan_arr
        for req in plan_arr:
            dict = {}
            req_arr = req.split(",")
            length = len(req_arr)

            if length >= 1: dict['term'] = req_arr[0].replace("\n", '')
            else: dict['term'] = ''

            if length >= 2: dict['requirement'] = req_arr[1].replace("\n", '')
            else: dict['requirement'] = ''
            
            if length >= 3: dict['fillers'] = req_arr[2:]
            else: dict['fillers'] = []

            plan_list = plan_list + [dict]
        
        return plan_list

    def terms(self):
        plan = self.plan()

        term_list = [None]
        for req in plan:
            term_list[int(req['term'])] = term_list[int(rep['term'])] + [req]

        return term_list

            
    def quit(self):
        self.socket.send("exit\n")

web.webapi.internalerror = web.debugerror
if __name__ == "__main__": web.run(urls, globals(), web.reloader)
