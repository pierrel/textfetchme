import time
import sha

import web

###web.config.db_parameters = {
###				'dbn' : 'postgres',
###				'host' : 'localhost',
###				'user' : 'web',
###				'pw' : 'web',
###				'db' : 'web'
###			}

web.config.db_parameters = {
				'dbn' : 'sqlite',
				'db' : 'web.db'
			}

web.config.db_printing = True

urls = (
	'/(.*)', 'index'
)

class index:
	def GET( self, rest ):
		web.config.session_parameters.handler = 'file'
		print 'don\'t forget to create sqlite db-file web.db and table session_data'
		print '------------------------------------'
		print 'added to url: ', rest
		print '------------------------------------'
		print 'client cookies at start: ', web.cookies()
		print '------------------------------------'

		s = web.ctx.session
		print s._generate_id()
		print '------------------------------------'

		h = web.session.FileHandler()

		time_ = int(time.time())
		ip = web.ctx.ip
		id = s._generate_id()

		data = {'a': '1', 'bb': 2, 'c': 333, '4': 'dddd'}

		print 'time: ', time_, 'ip: ', web.ctx.ip, 'id: ', id
		print '------------------------------------'

		print 'storing: ', data
		print '------------------------------------'
		h.store(id, ip, data)

		print 'retrieving ...'
		print '------------------------------------'
		res = h.retreive(id)

		print 'retreived: ', res
		print '------------------------------------'

		if id == res['id']:
			print 'id matches'
		print '------------------------------------'

		if time_ == res['touched']:
			print 'time matches'
		print '------------------------------------'

		if ip == res['ip']:
			print 'ip matches'
		print '------------------------------------'

		if data == res['data']:
			print 'data matches'
		print '------------------------------------'

		old_id = id
		old_time_ = time_

		time_ = int(time.time())
		id = s._generate_id()

		print 'changing id: ', id
		print '------------------------------------'

		old_data = data.copy()

		del data['a']
		data['bb'] = True
		data['c'] = '3'
		data['eeeee'] = 5

		print 'changing data: ', data
		print '------------------------------------'

		print 'storing new data ...'
		print '------------------------------------'
		h.store(id, ip, data, old_id)

		print 'retrieving new data ...'
		print '------------------------------------'
		res = h.retreive(id)

		print 'retreived: ', res
		print '------------------------------------'

		if id == res['id']:
			print 'id matches'
		print '------------------------------------'

		if time_ == res['touched']:
			print 'time matches'
		print '------------------------------------'

		if ip == res['ip']:
			print 'ip matches'
		print '------------------------------------'

		if data == res['data']:
			print 'data matches'
		print '------------------------------------'

		print 'removing ...'
		h.remove(id)
		print 'done'
		print '------------------------------------'

		print 'trying to retrieve ...'
		print '------------------------------------'
		res = h.retreive(id)
		print 'retrieved: "', res, '"'
		print '------------------------------------'

		print 'removing all expired sessions ...'
		h.clean(web.config.session_parameters.timeout)
		print 'done'
		print '------------------------------------'

		print 'starting session ...'
		s.start()
		print '------------------------------------'

		print 'got session: ', s
		print '------------------------------------'

		s.a = '1'
		s['22'] = {'b': 'b'}
		s.ccc = (3, True)
		s.time = time.strftime('%a, %d %b %Y %H:%M:%S')
		print 'changed data: ', s
		print '------------------------------------'

		print '<!--'
		print web.ctx
		print '-->'

		#h.store(s.get_id(), web.ctx.ip.replace('0', '1'), s._data)

web.webapi.internalerror = web.debugerror

if __name__ == '__main__':
	web.run(urls, globals(), web.reloader)
