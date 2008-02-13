import web
from ZopePageTemplates import PageTemplate
from os import curdir, sep

class PageTamplate(PageTemplate):
    def __call__(self, context={}, *args):
        if not context.has_key('args'):
            context['args'] = args
        return self.pt_render(extra_context=context)
    

urls = (
    '/', 'index')
views = 'views'

class index:
    template_file = open(views + '/' + 'index' + '.zpt')
    pt = PageTemplate()
    pt.write(template_file.read())

    def GET(self):
        print self.pt(context = {'here' : self})
    
    def title(self):
        return 'this is the title from ' + self.__class__.__name__ 

x = index()
x.GET()
#web.webapi.internalerror = web.debugerror
#if __name__ == "__main__": web.run(urls, globals(), web.reloader)
