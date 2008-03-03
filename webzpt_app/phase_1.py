from webzpt import WebZPTController, web
import re
import socket



urls = (
    '/login', 'login',
    '/threads', 'threads',
    '/schedule', 'schedule',
    '/index', 'index',
    '/search', 'search')


class index(WebZPTController):
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
        thisStudent = student()
        print self.view(partials=(thisStudent,)) #The trailing ',' is necessary for it to be understood as a tuple when it has only one element
        thisStudent.quit()

class search(WebZPTController):
    def POST(self):
        # get query
        params = web.input()
        query = params['query']
        
        # connect to Carter
        gtid = '900123456'
        password = 'a'
        
        # open socket
        self.addr = ('localhost', 7272)
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.connect(self.addr)
        if self.socket.send(gtid + "\n") < len(gtid)-1: raise CountNotConnectToCarter, "couldn't send gtid"
        if self.socket.send(password+"\n") < len(password)-1: raise CountNotConnectToCarter, "couldn't send password"
        
        # retrieve name
        self.socket.send("name\n")
        self.name = self.socket.recv(1024).replace("0\t", '')
        
        # switch threads, since we're never saving what threads we're using
        self.socket.send("create pl-embodimentintelligence\n")
        self.socket.recv(1024)
        self.socket.send("switch pl-embodimentintelligence\n")
        self.socket.recv(1024)
        
        # get CharlesML for gt-mathematics
        self.socket.send("possibles gt-mathematics\n")
        possibles = self.socket.recv(16384)
        
        # close the socket; we don't need it anymore
        self.socket.send("exit\n")
        
        # split bindables into three lists
        courses = possibles[2:].split(",")
        
        ret  = "<table><tbody>"
        
        for course in courses:
            if course.find(query) > -1: ret += "<tr class=\"creditblock\"><th class=\"coursenumber\">" + str(course) + "</th><td class=\"coursename\">Fetch from Carter</td></tr>"
        ret += "</tbody></table>\n"
        
        print ret

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

        # Set up a cache for terms so they aren't continually recalculated
        self.termsCache = None
       
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
        if self.termsCache != None:
            return self.termsCache

        plan = self.plan()

        terms = {}

        for requirement in plan:
            termNum = int(requirement['term'])
            if not terms.has_key(termNum):
                terms[termNum] = []
            terms[termNum] = terms[termNum] + [requirement]

        # Cache so we don't have to recompute this every time
        self.termsCache = terms
        return terms

    def termsJavascript(self):
        ret  = "// <![CDATA[\n\n"
        ret += "var activeSemesters = ["

        individualTerms = self.terms()
        termNumbers = []

        for term in range(1, len(individualTerms)):
            termNumbers += ["'term" + str(term) + "'"]

        ret += ",".join(termNumbers)

        ret += "]\n\n"

        ret += "for(var i = 0; i < activeSemesters.length; i++) {\n"
        ret += "  Sortable.create(activeSemesters[i],\n"
        ret += "    {tag:'tr',treeTag:'tbody',dropOnEmpty:true,containment:activeSemesters,constraint:false,hoverclass:'drag_into'});\n"
        ret += "}\n\n"

        ret += "// ]]>"

        return ret
    
    
    def quit(self):
        self.socket.send("exit\n")

web.webapi.internalerror = web.debugerror
if __name__ == "__main__": web.run(urls, globals(), web.reloader)
