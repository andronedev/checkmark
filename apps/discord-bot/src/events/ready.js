const { MessageEmbed, Message } = require('discord.js');
const { roles } = require('../data/roles');

module.exports = async (client) => {
    console.log('ready event');
    console.log(`Logged in as ${client.user.tag}!`);

    await client.user.setPresence({
        activity: {
            type: 'PLAYING',
            name: 'construire le futur',
        },
        status: 'online'
    });

    // setup reaction for rules
    const channel = await client.channels.fetch(process.env.DISCORD_CHANNEL_RULES);
    const message = await channel.messages.fetch(process.env.DISCORD_MESSAGE_RULES);
    const emojis = await client.guilds.cache.first().emojis;

    await message.react(await emojis.cache.find((value) => value.name === "done"));
    await message.react(await emojis.cache.find((value) => value.name === "cancelled"));

    // update roles sections
    const roleChannel = await client.channels.fetch(process.env.DISCORD_CHANNEL_ROLES);

    roles.map(async (role) => {
        const messageRole = await roleChannel.messages.fetch(process.env[role.messageIdEnvName]);
        const newMessageRole = new MessageEmbed()
            .setColor('#0099ff')
            .setTitle(role.title)
            .setDescription(role.description)
            .addFields(role.fields)
            .setFooter('Checkmark', 'https://www.checkmark.dev/icon.png')
            .setTimestamp()
        ;
        messageRole.edit(newMessageRole);
    });
}
