module.exports = ()->
	wwwCheck = /^www\./

	(req, res, next)->
		unless wwwCheck.exec req.headers.host
			secure = req.connection.encrypted or req.headers['x-forwarded-proto'] == 'https'
			isSubdomain = req.headers.host.split('.').length > 2

			if isSubdomain
				return next()

			prefix = if secure then 'https://' else 'http://'
			url  = prefix + 'www.' + req.headers.host + req.url

			res.writeHead 301, { location: url }
			res.end()

		next()