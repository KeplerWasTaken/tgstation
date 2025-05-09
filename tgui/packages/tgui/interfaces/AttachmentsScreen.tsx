import { Button, Divider, DmIcon, Icon, Stack } from 'tgui-core/components';
import { Window } from '../layouts';
import { useBackend } from '../backend';

type AttachmentsProps = {
    attachments: Attachment[];
    cells: Cell[];
    name: string;
    description: string;
    durability: number;
    maxdurability: number;
    icon: string;
    icon_state: string;
    uid: number;
};

type Attachment = {
    name: string;
    icon: string;
    icon_state: string;
    desc: string;
    uid: number;
};

type Cell = {
    name: string;
    charge: number;
    maxcharge: number;
    description: string;
    icon: string;
    icon_state: string;
    uid: number;
};

export const AttachmentsScreen = (props) => {
    const { act, data } = useBackend<AttachmentsProps>();
    return (
        <Window width={800} height={400}>
            <Window.Content>
                <Stack>
                    <Stack vertical width="35%">
                        <DmIcon
                            icon={data.icon}
                            icon_state={data.icon_state}
                            verticalAlign="middle"
                            height={'144px'}
                            width={'144px'}
                            fallback={<Icon name="spinner" size={2} spin />}
                        />
                    </Stack>
                    <Stack vertical width="65%">
                        {data.description}
                    </Stack>
                </Stack>
                <Divider />
                <Stack>
                    <h1> Stats </h1>
                    <Stack>
                        <Stack vertical width="35%">
                            <Stack>
                                Durability: {data.durability} /
                                {data.maxdurability}
                            </Stack>
                            <Stack>Name: {data.name}</Stack>
                        </Stack>
                        <Stack vertical width="65%">
                            {data.cells?.map((cell: Cell) => (
                                <Stack width="100%">
                                    {cell.name}
                                    {100 * (cell.charge / cell.maxcharge)}%
                                    {cell.description}
                                    <DmIcon
                                        icon={cell.icon}
                                        icon_state={cell.icon_state}
                                        verticalAlign="middle"
                                        height={'72px'}
                                        width={'72pxpx'}
                                        fallback={
                                            <Icon
                                                name="spinner"
                                                size={2}
                                                spin
                                            />
                                        }
                                    />
                                    <Button
                                        bold
                                        children="Remove"
                                        onClick={() =>
                                            act('ATC_REMOVE', {
                                                attachment_id: cell.uid,
                                            })
                                        }
                                    />
                                </Stack>
                            ))}
                        </Stack>
                    </Stack>
                </Stack>
                <Divider />
                <Stack>
                    <h1> Modular Slots </h1>
                    <Stack width="100%">
                        {data.attachments?.map((attachment: Attachment) => (
                            <Stack width="100%">
                                <Stack vertical width="35%">
                                    <DmIcon
                                        icon={attachment.icon}
                                        icon_state={attachment.icon_state}
                                        verticalAlign="middle"
                                        height={'72px'}
                                        width={'72pxpx'}
                                        fallback={
                                            <Icon
                                                name="spinner"
                                                size={2}
                                                spin
                                            />
                                        }
                                    />
                                </Stack>
                                <Stack vertical width="65%">
                                    {attachment.name}
                                    {attachment.desc}
                                    <Button
                                        bold
                                        children="Remove"
                                        onClick={() =>
                                            act('ATC_REMOVE', {
                                                attachment_id: attachment.uid,
                                            })
                                        }
                                    />
                                </Stack>
                            </Stack>
                        ))}
                    </Stack>
                </Stack>
            </Window.Content>
        </Window>
    );
};
