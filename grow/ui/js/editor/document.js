/**
 * Document for the editor.
 */

import Config from '../utility/config'
import { fieldGenerator } from './field'

export default class Document {
  constructor(podPath, fieldMeta, frontMatter, servingPaths, defaultLocale) {
    this.podPath = podPath
    this.fieldMeta = fieldMeta
    this.frontMatter = new Config(frontMatter)
    this.servingPaths = servingPaths
    this.defaultLocale = defaultLocale
    this.fields = []

    for (const meta of this.fieldMeta) {
      const field = fieldGenerator(meta['type'], meta['key'])
      this.fields.push(field)
    }
  }
}
