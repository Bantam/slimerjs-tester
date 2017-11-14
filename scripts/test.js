var page = require('webpage').create();

page.viewportSize = {
	width: 1920,
	height: 1080
};

const url = 'http://bbc.com/news';

console.log('Testing', url)

page.open(url).then(function(status) {
	setTimeout(function() {
		if (status === 'success') {
			console.log('Success with', url);
			page.render('/output/testimages/viewportHeight1080.png', {format: 'png', onlyViewport: true});

			console.log('Trying 1080px height');

			// let's see if it's a viewport height scrolling issue
			page.viewportSize = {
				width: 1920,
				height: page.evaluate(function() {
					return document.body.offsetHeight
				})
			};

			setTimeout(function() {
				page.render('/output/testimages/viewportHeightFullLengthOfPage.png', {format: 'png', onlyViewport: true});

				console.log('Trying calculated full height');

				// let's see if it's a viewport height scrolling issue
				page.viewportSize = {
					width: 1920,
					height: page.evaluate(function() {
						return document.body.offsetHeight + 1024
					})
				};

				setTimeout(function() {
					console.log('Trying calculated full height + 1024');

					page.render('/output/testimages/viewportHeightFullLengthOfPagePlus1024.png', {format: 'png', onlyViewport: true});

					page.close();
					slimer.exit();
				}, 1000);
			}, 1000);
		} else {
			console.log('Sorry, the page is not loaded');
		}
	}, 3000);
});