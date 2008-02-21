import web
from ZopePageTemplates import PageTemplate
from os import curdir, sep

class PageTemplate(PageTemplate):
   def __call__(self, context={}, *args):
      if not context.has_key('args'):
         context['args'] = args
      return self.pt_render(extra_context=context)

views_dir = curdir + sep + 'views' + sep
defined_controllers = {}

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
          if type(partials) == tuple:
             for partial in partials:
                context[partial.__class__.__name__] = partial
          else:
             context[partials.__class__.__name__] = partials
          context['here'] = self
       else:
          if context == {}:
             context = {self.__class__.__name__:self}
          else:
             context['here'] = self
          
       content = self.view_content()
       self.template.write(content)
       #try:
       template = self.template(context=context)
       #except KeyError, keys:
       #   for string in keys:
       #      if globals().has_key(string):
       #         partial_class = globals()[string]
       #         context[string] = new_partial
       #      else:
       #         raise PartialNotFoundError, "No partial named '%s'" % globals()
       #   template = self.template(context=context)
       return template

    def GET(self):
       '''
       The default GET will print out the view to the page with the
       appropriate context.
       '''
       print self.view()

    def _view_file(self):
       return open(views_dir + self.__class__.__name__ + '.zpt')
          

    def view_content(self):
       try:
          file = self._view_file()
          return file.read()
       except IOError:
          return "Please create '%s.zpt' in '%s' before calling it's controller or using it as a partial" % (self.__class__.__name__, views_dir)


class PartialNotFoundError(Exception):
   pass

#Helper methods
def class_from(string):
   if globals().has_key(string):
      return globals()#[string]
   else:
      return None
