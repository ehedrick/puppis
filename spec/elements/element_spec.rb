require 'spec_helper'

describe Puppis::Elements::Element do
  let(:subject){ Puppis::Elements::Element.new({class: 'foo'}) }
  before(:all) { Puppis::Config.platform = :ios }

  describe '#initialize' do
    it 'sets the identifier' do
      expect(subject.identifier).to_not be_nil
      expect(subject.identifier).to include 'foo'
    end
  end

  describe '#text' do
    context 'when the element exists' do
      it 'returns a string' do
        allow(subject).to receive(:query) { [{'text' => 'fe fi fo fum'}] }
        expect(subject.text).to eq 'fe fi fo fum'
      end
    end
    context 'when the element doesn\'t exist' do
      it 'raises an error' do
        allow(subject).to receive(:query) { [] }
        expect{subject.text}.to raise_exception Puppis::Elements::ElementNotFoundError
      end
    end
  end

  describe '#element_touch' do
    context 'when the element doesn\'t exist' do
      it 'raises an error' do
        allow(subject).to receive(:query) { [] }
        expect{subject.element_touch}.to raise_exception Puppis::Elements::ElementNotFoundError
      end
    end
    context 'when the element exists' do
      it 'touches the element' do
        allow(subject).to receive(:query) { [{'text' => 'fe fi fo fum'}] }
        expect(subject).to receive(:wait_tap).once
        expect(subject).to receive(:wait_for_none_animating)
        subject.element_touch
      end
    end
  end

  describe '#element_wait_for' do
    context 'when the element does not exist' do
      it 'raises an exception' do
        allow(subject).to receive(:query) { [] }
        allow(subject).to receive(:wait_for) { raise Exception }
        expect{subject.element_wait_for}.to raise_exception Exception
      end
    end
    context 'when the element does exist' do
      it 'returns true' do
        allow(subject).to receive(:query) { [{}] }
        expect(subject.element_wait_for).to eq true
      end
    end
    context 'with options' do
      it 'passes the options into wait' do
        expect(subject).to receive(:wait_for).with({foo: 'bar'})
        subject.element_wait_for(foo: 'bar')
      end
    end
  end

  describe '#exists?' do
    it 'returns true if the element exists' do
      allow(subject).to receive(:query){[{}]}
      expect(subject.exists?).to be_truthy
    end

    it 'returns false if the element does not exist' do
      allow(subject).to receive(:query) { [] }
      expect(subject.exists?).to be_falsey
    end
  end

  describe '#value=' do
    it 'sets the value of the element' do
      allow(subject).to receive(:query){[{}]}
      allow(subject).to receive(:element_touch){}
      allow(subject).to receive(:tap_keyboard_action_key){}
      allow(subject).to receive(:wait_for_none_animating){}
      expect(subject).to receive(:keyboard_enter_text).with('some text')
      subject.value = 'some text'
    end
  end
end