#[starknet::interface]
pub trait ICounterContract<TContractState> {
    fn get_counter(self: @TContractState) -> u32;
    fn increase_counter(ref self: TContractState);
    fn set_counter(ref self: TContractState, new_counter: u32);
}

#[starknet::contract]
pub mod counter_contract {
    use counter::counter::ICounterContract;
    use starknet::event::EventEmitter;

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CounterIncreased: CounterIncreased,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterIncreased {
        value: u32,
    }

    #[storage]
    struct Storage {
        counter: u32,
    }

    fn constructor(ref self: ContractState, intial_value: u32) {
        self.counter.write(intial_value);
    }

    #[abi(embed_v0)]
    impl CounterImpl of ICounterContract<ContractState> {
        fn get_counter(self: @ContractState) -> u32 {
            self.counter.read()
        }
        fn set_counter(ref self: ContractState, new_counter: u32) {
            self.counter.write(new_counter);
        }

        fn increase_counter(ref self: ContractState) {
            self.counter.write(self.get_counter() + 1);
            self.emit(CounterIncreased { value: self.get_counter() })
        }
    }
}
