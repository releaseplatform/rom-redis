describe ROM::Redis::Relation do
  include_context 'container'

  subject { rom.relation(:users) }

  before do
    configuration.relation(:users)
  end

  it '#set' do
    expect(subject.set(:a, 1).to_a).to eq(['OK'])
  end

  it '#hset' do
    expect(subject.hset(:who, :is, :john).to_a).to eq([true])
  end

  it '#hget' do
    subject.hset(:users, :john, :doe).to_a

    expect(subject.hgetall(:users).to_a).to eq([{ 'john' => 'doe' }])
  end

  describe '#keys' do
    it 'should return an enumerator' do
      expect(subject.keys).to be_a(Enumerable)
    end

    it 'should return all keys' do
      subject.set(1, 1).set(2, 2).set(3, 3).to_a

      expect(subject.keys.map { |h| h }).to include('1', '2', '3')
    end

    it 'should return all keys that match pattern' do
      subject.set('a:1', 1).set('a:2', 2).set('b:1', 1).to_a

      expect(subject.keys('a:*').map { |h| h }.length).to eq(2)
    end

    it 'iterates over the key space' do
      subject.hmset(0, :a, 1, :b, 2).to_a

      expect(subject.keys.map { |h| subject.hgetall(h).to_a.first }).to eq([{ 'a' => '1', 'b' => '2' }])
    end
  end
end
