import { Socket } from 'phoenix';

const socket = new Socket('/socket', {params: {token: window.userToken}});

socket.connect();

const createSocket = topicId => {
  const channel = socket.channel(`comments:${topicId}`, {});
  channel.join()
    .receive('ok', resp => { console.log('Joined successfully', resp) })
    .receive('error', resp => { console.log('Unable to join', resp) });

  document.querySelector('button').addEventListener('click', () => {
    const content = document.getElementById('comment').value;

    channel.push('comment:add', { content });
  });
};

window.createSocket = createSocket;
