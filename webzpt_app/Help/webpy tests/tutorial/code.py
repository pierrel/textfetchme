import web

render = web.template.render('templates/', cache=False)

urls = (
    '/(.*)', 'index')

class index:
    def GET(self, name):
        print render.index(name)

web.webapi.internalerror = web.debugerror
if __name__ == "__main__": web.run(urls, globals(), web.reloader)
