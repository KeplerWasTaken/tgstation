import { Section, Stack, Button } from "tgui-core/components";
import { useBackend } from "../../backend";
import { InviteData, NtosMissionFinderData } from "../NtosMissionFinder";

export const InviteSent = (props) => {
	const { invite } = props;
	const { act, data } = useBackend<NtosMissionFinderData>();

	const {
		user,
		currentmissionData,
	} = data;

	return (
		<Section>
			<Stack align="baseline">
				<Stack.Item grow bold>
					An invitiation to: {invite.recipientName}

					{
						currentmissionData.mission_hostername == user ?
							<Button
								bold
								children="Revoke Invite"
								onClick={() =>
									act('MF_revokeinvite', {
										revokeCkey: invite.recipientCkey
									})
								}
							/>
							: ""
					}

				</Stack.Item>
			</Stack>
		</Section>
	);
};
