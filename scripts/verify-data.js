#!/usr/bin/env node
'use strict'

const fs = require('fs')
const path = require('path')

const dataDir = path.join(__dirname, '..', 'minecraft-assets', 'data')
if (!fs.existsSync(dataDir)) {
  throw new Error(`missing data dir: ${dataDir}`)
}

const versions = fs.readdirSync(dataDir).filter((entry) => {
  const full = path.join(dataDir, entry)
  return fs.statSync(full).isDirectory()
})

if (versions.length === 0) {
  throw new Error(`no versions found in ${dataDir}`)
}

console.log(`[verify-data] found ${versions.length} versions in ${dataDir}`)
