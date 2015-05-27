{assert} = require 'chai'
theme = require '../lib/main'

describe 'Layout', ->
  it 'Should include API title & description', (done) ->
    ast =
      name: 'Test API'
      description: 'I am a [test](http://test.com/) API.'

    theme.render ast, (err, html) ->
      if err then return done err
      assert.include html, 'Test API'
      assert.include html, 'I am a <a href="http://test.com/">test</a> API.'
      done()

  it 'Should render custom code in markdown', (done) ->
    ast =
      description: 'Test\n\n```coffee\na = 1\n```\n'

    theme.render ast, (err, html) ->
      if err then return done err
      assert.include html, 'a = <span class="hljs-number">1</span>'
      done()

  it 'Should auto-link headings in markdown', (done) ->
    ast =
      description: '# Custom Heading'

    theme.render ast, (err, html) ->
      if err then return done err
      assert.include html, '<h1 id="header-custom-heading">'
      assert.include html, '<a class="permalink" href="#header-custom-heading">'
      done()

  it 'Should include API hostname', (done) ->
    ast =
      metadata: [
        {name: 'HOST', value: 'http://foo.com/'}
      ]

    theme.render ast, (err, html) ->
      if err then return done err
      assert.include html, 'http://foo.com/'
      done()

  it 'Should include resource group name & description', (done) ->
    ast =
      resourceGroups: [
        name: 'Frobs'
        description: 'A list of *Frobs*'
        resources: []
      ]

    theme.render ast, (err, html) ->
      if err then return done err
      assert.include html, 'Frobs'
      assert.include html, 'A list of <em>Frobs</em>'
      done()

  it 'Should include resource information', (done) ->
    ast =
      resourceGroups: [
        name: 'Frobs'
        resources: [
          name: 'Test Resource'
          description: 'Test *description*'
          actions: []
        ]
      ]

    theme.render ast, (err, html) ->
      if err then return done err
      assert.include html, 'Test Resource'
      assert.include html, 'Test <em>description</em>'
      done()

  it 'Should include action information', (done) ->
    ast =
      resourceGroups: [
        name: 'TestGroup'
        resources: [
          name: 'TestResource'
          parameters: []
          actions: [
            name: 'Test Action',
            description: 'Test *description*'
            method: 'GET'
            parameters: [
              name: 'paramName'
              description: 'Param *description*'
              type: 'bool'
              required: true
              values: []
            ]
            examples: [
              name: ''
              description: ''
              requests: [
                name: '200'
                headers: []
                body: '{"error": true}'
                schema: ''
              ]
              responses: []
            ]
          ]
        ]
      ]

    theme.render ast, (err, html) ->
      if err then return done err
      assert.include html, 'Test Action'
      assert.include html, 'Test <em>description</em>'
      assert.include html, 'GET'
      assert.include html, 'paramName'
      assert.include html, 'Param <em>description</em>'
      assert.include html, 'bool'
      assert.include html, 'required'
      assert.include html, 'true'
      done()