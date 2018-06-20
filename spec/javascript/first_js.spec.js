import { expect } from 'chai'
import { shallowMount } from '@vue/test-utils'
import messageBar from '../../app/javascript/packs/components/message_bar.vue'

describe('message_bar.vue', () => {
  it('shows the dogs message', () => {
    const wrapper = shallowMount(messageBar)
    expect(wrapper.find('p').text()).contains('who let the canary out')
  })
})
