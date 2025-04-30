import { useBackend } from '../backend';
import { Button, ColorBox, Section, Stack, Table } from '../components';
import { NtosWindow } from '../layouts';
import { NTOSData } from '../layouts/NtosWindow';

export type RequisitionsData = {
  user_credits: number,
  user_name: string,
  shop_items: PurchaseableItem[]
};
export type PurchaseableItem = {
  item_name: string;
  item_price: number;
  item_icon: string;
}

export const RemoteRequisitions = (props) => {
  const { act, data } = useBackend<RequisitionsData>();
  const {
    user_credits,
    user_name,
    shop_items
  } = data;

  return (
    <NtosWindow
      title={
        'Remote Requistions Remote'
      }
      width={400}
      height={500}
      z
    >
      Hello {user_name} with {user_credits}cr
      <NtosWindow.Content scrollable>
        {
          shop_items.map((shop_item) => (
            <PurchaseableItemDisplay item={shop_item}>
            </PurchaseableItemDisplay>
          ))
        }
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const PurchaseableItemDisplay = (props) => {
  const { act, data } = useBackend<NTOSData>();

  var { item } = props as {
    item: PurchaseableItem
  };

  return (
    <Stack>
      {item.item_name} - {item.item_price}
    </Stack>
  );
};
