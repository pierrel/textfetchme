import web
from ZopePageTemplates import PageTemplate
from os import curdir, sep

class PageTemplate(PageTemplate):
   def __call__(self, context={}, *args):
      if not context.has_key('args'):
         context['args'] = args
      return self.pt_render(extra_context=context)

views_dir = curdir + sep + 'views' + sep

class WebZPTController:
    '''
    This class will be inherited by any class in the webpy
    application that wants to use Zope Page Templates
    '''
    template = PageTemplate()

    def view(self, context = {}, partials = ()):
       '''
       Every controller will contain a view that displays it's
       zpt file in the views folder.
       '''
       if not partials == ():
          for partial in partials:
             context[partial.__class__.__name__] = partial
          context['here'] = self
       else:
          if context == {}:
             context = {self.__class__.__name__:self}
          else:
             context = {'here':self}
          
       content = self.as_partial()
       self.template.write(content)
       return self.template(context = context)

    def GET(self):
       '''
       The default GET will print out the view to the page with the
       appropriate context.
       '''
       print self.view()

    def _view_file(self):
       return open(views_dir + self.__class__.__name__ + '.zpt')
          

    def as_partial(self):
       try:
          file = self._view_file()
          return file.read()
       except IOError:
          return "<html><body>Please create '%s.zpt' in '%s' before calling it's controller or using it as a partial" % (self.__class__.__name__, views_dir)
