import { Socket } from 'phoenix';

const socket = new Socket('/socket', {params: {token: window.userToken}});

socket.connect();

const createSocket = topicId => {
  const channel = socket.channel(`comments:${topicId}`, {});
  channel.join()
    .receive('ok', ({ comments }) => {
      document.getElementById('comments').innerHTML = renderComments(comments).join('');
    })
    .receive('error', resp => { console.log('Unable to join', resp) });

  document.querySelector('button').addEventListener('click', () => {
    const content = document.getElementById('comment').value;

    channel.push('comment:add', { content });
  });

  channel.on(`comments:${topicId}:new`, ({ comment }) => {
    const item = renderComment(comment);
    document.getElementById('comments').innerHTML += item;
  });
};

const renderComment = ({ content }) => `<li class="collection-item">${content}</li>`;

const renderComments = comments =>
  comments.map(renderComment) ;

window.createSocket = createSocket;
