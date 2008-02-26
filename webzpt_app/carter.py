import socket
import re

class carter:
    def __init__(self, host, port):
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.connect((host, port))

    def login(self, gtid, password):
        if self.socket.send(str(gtid) + "\n") < len(str(gtid))-1: raise CouldNotConnectToCarter, "couldn't send gtid"
        if self.socket.send(str(password) + "\n") < len(password)-1: raise CouldNotConnectToCarter, "couldn't send password"
        recv = self.socket.recv(1024)
        if not int(recv[0]) == 0: raise CarterAuthenticationFailed, "error status: %s" % str(recv)
        
    def logout(self):
        if self.socket.send("exit\n") < len("exit\n")-1: raise CouldNotConnectToCarter, "couldn't logout"

        recv = self.socket.recv(1024)
        if not int(recv[0]) == 0: raise CarterAuthenticaionFailed, "error status: %s" % str(recv)

    def send(self, command, args = []):
        self.socket.send(str(command) + "\t".join([str(arg) for x in args]) + '\n')
        
        recv = self.socket.recv(1024)
        if not int(recv[0]) == 0: raise CarterAuthenticationFailed, "error status: %s" % str(recv)
        return cml2python(command, recv[2:])

'''
Dictionary holding instructions for each command to carter.
Strings are used to split the cml, nesting each successive
split into lists.
'''
carter_command_dict = {'ping': (re.compile('[\d.]+'),),
                       'history': (',', "\t"),
                       'plan', ("\\", ',')}
def cml2python(command, cml):
    '''
    Used in conjuction with carter_command_list to parse the returned
    CharlesML and turns the it into a list (usually a nested list).
    '''
    parsed = cml.replace("\n", '')#remove and newlines (usually found at the end of carter output)
    try:
        for parse_method in carter_command_dict[command]: #iterates through tuple of parsing commands
            if type(parse_method) == str:#if the pargin command is a string then uses a split
                if type(parsed) == str:
                    parsed = parsed.split(parse_method)
                else:
                    parsed = [x.split(parse_method) for x in parsed]
            else:#else it is a regex. matches the cml (or list of cml), replacing the cml with the matched data.
                if type(parsed) == str:
                    matched = parse_method.match(parsed)
                    if matched:
                        parsed = matched.group()
                elif type(parsed) == list:
                    parsed = [parse_method.match(parsed).group()]
        return parsed
    except KeyError, e:
        return cml
    

class CouldNotConnectToCarter(Exception): 
    pass

class CarterAuthenticationFailed(Exception):
    pass

class CarterLogoutFailed(Exception):
    pass
